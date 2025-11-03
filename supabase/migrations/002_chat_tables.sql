-- ============================
-- جداول نظام الدردشة
-- ============================

-- جدول المحادثات
CREATE TABLE IF NOT EXISTS conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    car_id UUID REFERENCES cars(id) ON DELETE CASCADE,
    buyer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    seller_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    last_message TEXT,
    last_message_at TIMESTAMPTZ,
    buyer_unread_count INT DEFAULT 0,
    seller_unread_count INT DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- منع تكرار المحادثة لنفس السيارة بين نفس المشتري والبائع
    UNIQUE(car_id, buyer_id, seller_id)
);

-- جدول الرسائل
CREATE TABLE IF NOT EXISTS messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    message_text TEXT NOT NULL,
    message_type VARCHAR(20) DEFAULT 'text' CHECK (message_type IN ('text', 'image', 'offer')),
    attachments TEXT[] DEFAULT ARRAY[]::TEXT[],
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- فهارس لتحسين الأداء
CREATE INDEX IF NOT EXISTS idx_messages_conversation_id ON public.messages (conversation_id);
CREATE INDEX IF NOT EXISTS idx_messages_created_at ON public.messages (created_at DESC);

-- ============================
-- سياسات RLS (Row Level Security)
-- ============================

-- تفعيل RLS على الجداول
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- سياسات جدول المحادثات
-- قراءة: المشتري أو البائع فقط
CREATE POLICY conversations_select_policy ON conversations
    FOR SELECT
    USING (auth.uid() = buyer_id OR auth.uid() = seller_id);

-- إنشاء: أي مستخدم مسجل
CREATE POLICY conversations_insert_policy ON conversations
    FOR INSERT
    WITH CHECK (auth.uid() IS NOT NULL);

-- تحديث: المشتري أو البائع فقط
CREATE POLICY conversations_update_policy ON conversations
    FOR UPDATE
    USING (auth.uid() = buyer_id OR auth.uid() = seller_id)
    WITH CHECK (auth.uid() = buyer_id OR auth.uid() = seller_id);

-- سياسات جدول الرسائل
-- قراءة: فقط المشاركين في المحادثة
CREATE POLICY messages_select_policy ON messages
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM conversations
            WHERE conversations.id = messages.conversation_id
            AND (conversations.buyer_id = auth.uid() OR conversations.seller_id = auth.uid())
        )
    );

-- إنشاء: فقط المشاركين في المحادثة
CREATE POLICY messages_insert_policy ON messages
    FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM conversations
            WHERE conversations.id = messages.conversation_id
            AND (conversations.buyer_id = auth.uid() OR conversations.seller_id = auth.uid())
        )
    );

-- تحديث: فقط المرسل (لتعديل حالة القراءة)
CREATE POLICY messages_update_policy ON messages
    FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM conversations
            WHERE conversations.id = messages.conversation_id
            AND (conversations.buyer_id = auth.uid() OR conversations.seller_id = auth.uid())
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM conversations
            WHERE conversations.id = messages.conversation_id
            AND (conversations.buyer_id = auth.uid() OR conversations.seller_id = auth.uid())
        )
    );

-- ============================
-- دوال مساعدة
-- ============================

-- دالة لتحديث آخر رسالة في المحادثة
CREATE OR REPLACE FUNCTION update_conversation_last_message()
RETURNS TRIGGER AS $$
BEGIN
    -- تحديث المحادثة بآخر رسالة
    UPDATE conversations
    SET 
        last_message = NEW.message_text,
        last_message_at = NEW.created_at,
        updated_at = NOW(),
        -- زيادة عداد الرسائل غير المقروءة للطرف الآخر
        buyer_unread_count = CASE 
            WHEN NEW.sender_id != buyer_id THEN buyer_unread_count + 1 
            ELSE buyer_unread_count 
        END,
        seller_unread_count = CASE 
            WHEN NEW.sender_id != seller_id THEN seller_unread_count + 1 
            ELSE seller_unread_count 
        END
    WHERE id = NEW.conversation_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger لتحديث المحادثة عند إضافة رسالة جديدة
CREATE TRIGGER trigger_update_conversation_on_new_message
    AFTER INSERT ON messages
    FOR EACH ROW
    EXECUTE FUNCTION update_conversation_last_message();

-- دالة لتصفير عداد الرسائل غير المقروءة
CREATE OR REPLACE FUNCTION mark_messages_as_read(
    p_conversation_id UUID,
    p_user_id UUID
)
RETURNS void AS $$
BEGIN
    -- تحديث حالة القراءة للرسائل
    UPDATE messages
    SET is_read = true, read_at = NOW()
    WHERE conversation_id = p_conversation_id
    AND sender_id != p_user_id
    AND is_read = false;
    
    -- تصفير عداد الرسائل غير المقروءة
    UPDATE conversations
    SET 
        buyer_unread_count = CASE 
            WHEN buyer_id = p_user_id THEN 0 
            ELSE buyer_unread_count 
        END,
        seller_unread_count = CASE 
            WHEN seller_id = p_user_id THEN 0 
            ELSE seller_unread_count 
        END,
        updated_at = NOW()
    WHERE id = p_conversation_id;
END;
$$ LANGUAGE plpgsql;

-- ============================
-- إضافة Realtime لتحديثات فورية
-- ============================
-- تفعيل Realtime على جدول الرسائل
ALTER PUBLICATION supabase_realtime ADD TABLE messages;
ALTER PUBLICATION supabase_realtime ADD TABLE conversations;
