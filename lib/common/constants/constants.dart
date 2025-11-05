import 'package:flutter/material.dart';

const Size designSize = Size(375, 812);
const kPerPage = 20;
const String privacyPolicyHTML_EN = """
<div style='color:#ffffff;'>
  <h1>Privacy Policy</h1>
  <p><strong>Last updated:</strong> 2025-11-05</p>

  <h2>Overview</h2>
  <p>
    Wolfera provides a marketplace to list, buy and sell cars, and a chat to communicate between users.
    We are committed to protecting your privacy and handling your data in accordance with the Google Play
    and Apple App Store requirements, and applicable privacy laws.
  </p>

  <h2>Information We Collect</h2>
  <ul>
    <li><strong>Account data:</strong> name, email, optional phone, profile photo (if provided), authentication identifiers (e.g., Google Sign-In).</li>
    <li><strong>Content you provide:</strong> car listing details and photos, messages in chat.</li>
    <li><strong>Device and app data:</strong> push notification token (FCM), app version, device OS for reliability and support.</li>
    <li><strong>Permissions:</strong> Camera (capture photos, optional scanning), Photos/Media (select images), Notifications, Vibration. We do not collect precise location.</li>
  </ul>

  <h2>How We Use Your Information</h2>
  <ul>
    <li>Provide core features: listings, chat, notifications.</li>
    <li>Authenticate users (including Google Sign-In) and maintain accounts.</li>
    <li>Improve reliability, prevent fraud/abuse, and provide support.</li>
    <li>Send service notifications (e.g., new messages). Marketing notifications are sent only with consent where required.</li>
  </ul>

  <h2>Legal Bases (EEA/UK)</h2>
  <ul>
    <li>Contract performance (provide services you request).</li>
    <li>Legitimate interests (security, service improvement).</li>
    <li>Consent (e.g., push notifications on iOS/Android; you can disable any time in system settings).</li>
    <li>Legal obligations (comply with applicable laws).</li>
  </ul>

  <h2>Sharing and Third Parties</h2>
  <ul>
    <li><strong>Supabase</strong> (database, authentication, storage) – stores your account data, listings, chat content, and images.</li>
    <li><strong>Firebase Cloud Messaging</strong> – generates device tokens and delivers push notifications.</li>
    <li><strong>Google Sign-In</strong> – used for OAuth authentication if you choose Google.</li>
    <li>Service providers under contract (infrastructure, error logging) – only to the extent necessary; no data is sold.</li>
    <li>Law enforcement/requests where required by law.</li>
  </ul>

  <h2>Data Retention</h2>
  <p>
    We retain your data while your account is active. If you request deletion, we delete or anonymize your personal data
    within a reasonable time unless we must retain it to comply with legal obligations or resolve disputes. Backups may
    persist for up to 90 days.
  </p>

  <h2>Your Rights</h2>
  <p>
    Subject to applicable law, you may have the right to access, correct, delete, or port your data, and to object or
    restrict certain processing. You can disable notifications at the system level. To submit a request, contact us at
    <a href='mailto:mohamad.adib.tawil@gmail.com'>mohamad.adib.tawil@gmail.com</a>.
  </p>

  <h2>Children’s Privacy</h2>
  <p>
    The service is not directed to children under 13 (or under 16 in certain regions). If we learn that we processed
    such data, we will delete it.
  </p>

  <h2>Security</h2>
  <p>
    We use industry-standard measures to protect data (TLS in transit; secure storage with Supabase). No security is
    perfect; please protect your account credentials.
  </p>

  <h2>International Transfers</h2>
  <p>
    Our service providers may process data in multiple regions. We use appropriate safeguards where required by law.
  </p>

  <h2>Permissions Used</h2>
  <ul>
    <li><strong>Camera:</strong> to capture photos of cars and optional scanning features.</li>
    <li><strong>Photos/Media:</strong> to select and upload car images.</li>
    <li><strong>Notifications:</strong> to inform you about messages and app activity.</li>
    <li><strong>Vibration:</strong> to provide haptic feedback on notifications.</li>
    <li><strong>Receive boot completed:</strong> to ensure notification services are re-initialized after reboot.</li>
  </ul>

  <h2>Changes</h2>
  <p>
    We may update this policy from time to time. We will post the updated version in-app and update the “Last updated” date.
  </p>

  <h2>Contact</h2>
  <p>Email: <a href='mailto:mohamad.adib.tawil@gmail.com'>mohamad.adib.tawil@gmail.com</a></p>
</div>
""";

const String privacyPolicyHTML_AR = """
<div style='color:#ffffff;'>
  <h1>سياسة الخصوصية</h1>
  <p><strong>آخر تحديث:</strong> 2025-11-05</p>

  <h2>نظرة عامة</h2>
  <p>
    يوفر تطبيق Wolfera منصة لعرض وبيع وشراء السيارات، بالإضافة إلى محادثة بين المستخدمين.
    نلتزم بحماية خصوصيتك والامتثال لمتطلبات متجر Google Play ومتجر Apple App Store والقوانين ذات الصلة.
  </p>

  <h2>البيانات التي نجمعها</h2>
  <ul>
    <li><strong>بيانات الحساب:</strong> الاسم، البريد الإلكتروني، الهاتف اختياري، صورة الملف الشخصي (إن وُجدت)، معرفات المصادقة (مثل تسجيل الدخول عبر Google).</li>
    <li><strong>المحتوى الذي تقدمه:</strong> تفاصيل الإعلانات وصور السيارات، ورسائل الدردشة.</li>
    <li><strong>بيانات الجهاز والتطبيق:</strong> رمز إشعارات الدفع (FCM)، إصدار التطبيق، نظام التشغيل لأغراض الاعتمادية والدعم.</li>
    <li><strong>الأذونات:</strong> الكاميرا (لالتقاط الصور ومسح اختياري)، الصور/الوسائط (لاختيار الصور)، الإشعارات، الاهتزاز. لا نجمع الموقع الدقيق.</li>
  </ul>

  <h2>كيفية استخدامنا لبياناتك</h2>
  <ul>
    <li>تقديم الميزات الأساسية: الإعلانات، الدردشة، الإشعارات.</li>
    <li>مصادقة المستخدمين (بما في ذلك Google) وإدارة الحسابات.</li>
    <li>تحسين الاعتمادية ومنع الاحتيال/إساءة الاستخدام وتقديم الدعم.</li>
    <li>إرسال إشعارات خدمية (مثل رسائل جديدة). تُرسل الإشعارات التسويقية بموافقتك حيثما يلزم.</li>
  </ul>

  <h2>الأسس القانونية (EEA/UK)</h2>
  <ul>
    <li>تنفيذ العقد (تقديم الخدمة التي تطلبها).</li>
    <li>المصلحة المشروعة (الأمان وتحسين الخدمة).</li>
    <li>الموافقة (مثل إشعارات الدفع على iOS/Android؛ يمكنك تعطيلها من إعدادات الجهاز).</li>
    <li>الالتزامات القانونية.</li>
  </ul>

  <h2>المشاركة مع جهات خارجية</h2>
  <ul>
    <li><strong>Supabase</strong> (قاعدة البيانات والمصادقة والتخزين) — تخزن بيانات الحساب والإعلانات والدردشة والصور.</li>
    <li><strong>Firebase Cloud Messaging</strong> — توليد رموز الأجهزة وتوصيل الإشعارات.</li>
    <li><strong>Google Sign-In</strong> — للمصادقة عبر Google إذا اخترت ذلك.</li>
    <li>مزودو خدمة بموجب عقود (بنية تحتية/سجلات أخطاء) — بالحد الأدنى اللازم؛ لا نبيع البيانات.</li>
    <li>الامتثال للجهات القانونية عند الطلب.</li>
  </ul>

  <h2>الاحتفاظ بالبيانات</h2>
  <p>
    نحتفظ ببياناتك طالما كان حسابك نشطاً. عند طلب الحذف، نقوم بحذف أو إخفاء هوية بياناتك خلال مدة معقولة ما لم نكن
    ملزمين بالاحتفاظ بها للامتثال للقانون أو لحل النزاعات. قد تبقى النسخ الاحتياطية حتى 90 يوماً.
  </p>

  <h2>حقوقك</h2>
  <p>
    وفقاً للقانون المطبق، قد يكون لديك حق الوصول إلى بياناتك وتصحيحها وحذفها ونقلها، والاعتراض أو تقييد معالجات معينة.
    يمكنك تعطيل الإشعارات من إعدادات النظام. لطلب أي إجراء، تواصل معنا عبر البريد:
    <a href='mailto:mohamad.adib.tawil@gmail.com'>mohamad.adib.tawil@gmail.com</a>.
  </p>

  <h2>خصوصية الأطفال</h2>
  <p>
    الخدمة غير موجهة لمن هم دون 13 عاماً (أو دون 16 في بعض المناطق). إذا علمنا بمعالجة كهذه، سنقوم بالحذف.
  </p>

  <h2>الأمان</h2>
  <p>
    نستخدم تدابير معيارية لحماية البيانات (TLS أثناء النقل؛ تخزين آمن عبر Supabase). لا توجد حماية مثالية؛ يرجى حماية بيانات دخولك.
  </p>

  <h2>نقل البيانات دولياً</h2>
  <p>
    قد تتم معالجة البيانات في عدة مناطق من قبل مزودي الخدمة. نستخدم الضمانات المناسبة حيثما يتطلب القانون.
  </p>

  <h2>الأذونات المستخدمة</h2>
  <ul>
    <li><strong>الكاميرا:</strong> لالتقاط صور السيارات وربما المسح.</li>
    <li><strong>الصور/الوسائط:</strong> لاختيار ورفع صور السيارات.</li>
    <li><strong>الإشعارات:</strong> لإعلامك بالرسائل والنشاط.</li>
    <li><strong>الاهتزاز:</strong> لتغذية راجعة حسية عند الإشعارات.</li>
    <li><strong>التشغيل بعد إعادة التشغيل:</strong> لضمان تهيئة الإشعارات بعد إعادة التشغيل.</li>
  </ul>

  <h2>التغييرات</h2>
  <p>
    قد نُحدّث هذه السياسة من وقت لآخر. سنعرض النسخة المحدثة داخل التطبيق ونحدّث تاريخ "آخر تحديث".
  </p>

  <h2>التواصل</h2>
  <p>البريد الإلكتروني: <a href='mailto:mohamad.adib.tawil@gmail.com'>mohamad.adib.tawil@gmail.com</a></p>
</div>
""";
