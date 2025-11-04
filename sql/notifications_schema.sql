-- إنشاء جدول الإشعارات
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    type TEXT NOT NULL DEFAULT 'general', -- types: general, new_message, new_offer, car_like, car_comment
    data JSONB DEFAULT '{}',
    read_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- إضافة الفهارس
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_sender_id ON public.notifications(sender_id);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON public.notifications(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_notifications_read_at ON public.notifications(read_at);
CREATE INDEX IF NOT EXISTS idx_notifications_type ON public.notifications(type);

-- تفعيل RLS
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- سياسة القراءة: المستخدم يمكنه قراءة إشعاراته فقط
CREATE POLICY "Users can view their own notifications" 
ON public.notifications 
FOR SELECT 
TO authenticated 
USING (user_id = auth.uid());

-- سياسة الإدراج: المستخدمون المصادق عليهم يمكنهم إرسال إشعارات
CREATE POLICY "Authenticated users can send notifications"
ON public.notifications
FOR INSERT
TO authenticated
WITH CHECK (true);

-- سياسة التحديث: المستخدم يمكنه تحديث إشعاراته فقط (تحديد كمقروء)
CREATE POLICY "Users can update their own notifications"
ON public.notifications
FOR UPDATE
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- سياسة الحذف: المستخدم يمكنه حذف إشعاراته فقط
CREATE POLICY "Users can delete their own notifications"
ON public.notifications
FOR DELETE
TO authenticated
USING (user_id = auth.uid());

-- تفعيل Realtime
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_publication_rel pr
    JOIN pg_class c ON c.oid = pr.prrelid
    JOIN pg_namespace n ON n.oid = c.relnamespace
    JOIN pg_publication p ON p.oid = pr.prpubid
    WHERE p.pubname = 'supabase_realtime'
      AND n.nspname = 'public'
      AND c.relname = 'notifications'
  ) THEN
    EXECUTE 'ALTER PUBLICATION supabase_realtime ADD TABLE public.notifications';
  END IF;
END $$;

-- Trigger لتحديث updated_at
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS set_updated_at ON public.notifications;
CREATE TRIGGER set_updated_at
    BEFORE UPDATE ON public.notifications
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

-- دالة RPC لإحصائيات الإشعارات غير المقروءة
CREATE OR REPLACE FUNCTION public.get_unread_notifications_count(p_user_id UUID)
RETURNS INT AS $$
BEGIN
    RETURN (
        SELECT COUNT(*)::INT
        FROM public.notifications
        WHERE user_id = p_user_id
        AND read_at IS NULL
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- دالة لإرسال إشعار عند رسالة جديدة (يمكن استدعاؤها من trigger)
CREATE OR REPLACE FUNCTION public.send_message_notification()
RETURNS TRIGGER AS $$
DECLARE
    v_conversation RECORD;
    v_sender RECORD;
    v_recipient_id UUID;
    v_message_preview TEXT;
BEGIN
    -- جلب معلومات المحادثة
    SELECT * INTO v_conversation 
    FROM public.conversations 
    WHERE id = NEW.conversation_id;
    
    -- تحديد المستقبل
    IF v_conversation.buyer_id = NEW.sender_id THEN
        v_recipient_id := v_conversation.seller_id;
    ELSE
        v_recipient_id := v_conversation.buyer_id;
    END IF;
    
    -- جلب معلومات المرسل
    SELECT * INTO v_sender 
    FROM public.users 
    WHERE id = NEW.sender_id;
    
    -- تجهيز معاينة الرسالة
    v_message_preview := NEW.message_text;
    IF LENGTH(v_message_preview) > 100 THEN
        v_message_preview := SUBSTRING(v_message_preview FROM 1 FOR 100) || '...';
    END IF;
    
    -- إدراج الإشعار
    INSERT INTO public.notifications (
        user_id,
        sender_id,
        title,
        body,
        type,
        data
    ) VALUES (
        v_recipient_id,
        NEW.sender_id,
        'رسالة جديدة من ' || COALESCE(v_sender.full_name, 'مستخدم'),
        v_message_preview,
        'new_message',
        jsonb_build_object(
            'conversation_id', NEW.conversation_id,
            'message_id', NEW.id,
            'action', 'open_chat'
        )
    );
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger لإرسال إشعار عند رسالة جديدة
DROP TRIGGER IF EXISTS trigger_send_message_notification ON public.messages;
CREATE TRIGGER trigger_send_message_notification
    AFTER INSERT ON public.messages
    FOR EACH ROW
    WHEN (NEW.message_type = 'text')
    EXECUTE FUNCTION public.send_message_notification();

-- إشعار للمستخدمين الذين أضافوا السيارة للمفضلة عند تغيير السعر
CREATE OR REPLACE FUNCTION public.notify_favorites_on_price_change()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.price IS DISTINCT FROM OLD.price THEN
    INSERT INTO public.notifications (
      user_id,
      sender_id,
      title,
      body,
      type,
      data
    )
    SELECT f.user_id,
           NEW.user_id,
           (CASE WHEN NEW.price < OLD.price THEN 'انخفاض سعر' ELSE 'تعديل سعر' END) || ' - ' || COALESCE(NEW.title, 'سيارة'),
           'السعر ' || (CASE WHEN NEW.price < OLD.price THEN 'انخفض' ELSE 'تغير' END) || ' من ' || OLD.price::text || ' إلى ' || NEW.price::text,
           (CASE WHEN NEW.price < OLD.price THEN 'price_drop' ELSE 'general' END),
           jsonb_build_object(
             'car_id', NEW.id,
             'old_price', OLD.price,
             'new_price', NEW.price,
             'action', 'view_car'
           )
    FROM public.favorites f
    WHERE f.car_id = NEW.id
      AND f.user_id IS DISTINCT FROM NEW.user_id; -- استثناء مالك السيارة
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS tr_notify_price_change ON public.cars;
CREATE TRIGGER tr_notify_price_change
  AFTER UPDATE OF price ON public.cars
  FOR EACH ROW
  WHEN (OLD.price IS DISTINCT FROM NEW.price)
  EXECUTE FUNCTION public.notify_favorites_on_price_change();

-- إشعار للمستخدمين الذين أضافوا السيارة للمفضلة عند تغيير الحالة (مثل تم البيع)
CREATE OR REPLACE FUNCTION public.notify_favorites_on_status_change()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status IS DISTINCT FROM OLD.status THEN
    INSERT INTO public.notifications (
      user_id,
      sender_id,
      title,
      body,
      type,
      data
    )
    SELECT f.user_id,
           NEW.user_id,
           'تحديث حالة السيارة - ' || COALESCE(NEW.title, 'سيارة'),
           'تم تغيير الحالة إلى: ' || NEW.status,
           'general',
           jsonb_build_object(
             'car_id', NEW.id,
             'status', NEW.status,
             'action', 'view_car'
           )
    FROM public.favorites f
    WHERE f.car_id = NEW.id
      AND f.user_id IS DISTINCT FROM NEW.user_id; -- استثناء مالك السيارة
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS tr_notify_status_change ON public.cars;
CREATE TRIGGER tr_notify_status_change
  AFTER UPDATE OF status ON public.cars
  FOR EACH ROW
  WHEN (OLD.status IS DISTINCT FROM NEW.status)
  EXECUTE FUNCTION public.notify_favorites_on_status_change();
