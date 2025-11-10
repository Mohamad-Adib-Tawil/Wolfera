-- جدول إعدادات التطبيق العامة (مثل إخفاء سوريا)
-- يجب تشغيل هذا السكريبت في Supabase SQL Editor

-- إنشاء الجدول
CREATE TABLE IF NOT EXISTS app_settings (
  id BIGSERIAL PRIMARY KEY,
  key TEXT UNIQUE NOT NULL,
  value JSONB,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- إضافة فهرس على key للبحث السريع
CREATE INDEX IF NOT EXISTS idx_app_settings_key ON app_settings(key);

-- إدراج القيمة الافتراضية لإخفاء سوريا (false = ظاهرة)
-- استخدام JSONB boolean بدلاً من نص
INSERT INTO app_settings (key, value, created_at, updated_at)
VALUES ('hide_syria', 'false'::jsonb, NOW(), NOW())
ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value;

-- سياسة RLS: السماح للجميع بالقراءة
ALTER TABLE app_settings ENABLE ROW LEVEL SECURITY;

-- إزالة السياسات إذا كانت موجودة مسبقاً لتجنب أخطاء التكرار
DROP POLICY IF EXISTS "Anyone can read app settings" ON app_settings;
DROP POLICY IF EXISTS "Only super admin can update app settings" ON app_settings;

CREATE POLICY "Anyone can read app settings"
  ON app_settings
  FOR SELECT
  USING (true);

-- سياسة RLS: السماح فقط للسوبر أدمن بالتحديث
CREATE POLICY "Only super admin can update app settings"
  ON app_settings
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid()
      AND users.is_super_admin = true
    )
  );

-- ملاحظة: تأكد من وجود عمود is_super_admin في جدول users
-- إذا لم يكن موجوداً، قم بإضافته:
-- ALTER TABLE users ADD COLUMN IF NOT EXISTS is_super_admin BOOLEAN DEFAULT false;
