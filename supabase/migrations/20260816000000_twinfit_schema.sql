-- TWINFIT MASTER DATABASE SCHEMA
-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. KULLANICI BİYOLOJİK PROFİLİ
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    full_name TEXT,
    gender TEXT CHECK (gender IN ('male', 'female', 'other')),
    birth_date DATE,
    height_cm NUMERIC(5,2),
    weight_kg NUMERIC(5,2),
    body_fat_percentage NUMERIC(4,2),
    torso_femur_ratio TEXT DEFAULT 'average' CHECK (torso_femur_ratio IN ('short_femur', 'average', 'long_femur')),
    arm_length_type TEXT DEFAULT 'average' CHECK (arm_length_type IN ('short', 'average', 'long')),
    joint_sensitivities TEXT[] DEFAULT '{}',
    fitness_goal TEXT NOT NULL DEFAULT 'hypertrophy' CHECK (fitness_goal IN ('hypertrophy', 'strength', 'recomp', 'endurance')),
    experience_level TEXT NOT NULL DEFAULT 'intermediate' CHECK (experience_level IN ('beginner', 'intermediate', 'advanced', 'elite')),
    cns_fatigue_capacity INTEGER DEFAULT 100,
    daily_calorie_target INTEGER DEFAULT 2400,
    daily_protein_target_g INTEGER DEFAULT 160,
    daily_carb_target_g INTEGER DEFAULT 260,
    daily_fat_target_g INTEGER DEFAULT 70,
    daily_water_target_ml INTEGER DEFAULT 3000,
    avatar_url TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- 2. BİYOMEKANİK EGZERSİZ KÜTÜPHANESİ
CREATE TABLE IF NOT EXISTS public.exercises (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    turkish_name TEXT NOT NULL,
    target_muscle TEXT NOT NULL,
    synergist_muscles TEXT[] DEFAULT '{}',
    cns_load_score INTEGER CHECK (cns_load_score BETWEEN 1 AND 10),
    sfr_rating TEXT CHECK (sfr_rating IN ('low', 'medium', 'high', 'elite')),
    joint_stress_index JSONB DEFAULT '{"shoulder": 0, "lower_back": 0, "knee": 0, "elbow": 0}'::jsonb,
    biomechanical_notes TEXT,
    execution_cues TEXT[] DEFAULT '{}',
    video_url TEXT,
    thumbnail_url TEXT,
    equipment TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. OTONOM ALTIN ROTA PROGRAMLARI
CREATE TABLE IF NOT EXISTS public.golden_path_routines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    routine_name TEXT NOT NULL,
    day_name TEXT NOT NULL,
    day_of_week INTEGER,
    focus_muscles TEXT[] DEFAULT '{}',
    total_cns_impact INTEGER DEFAULT 5,
    estimated_duration_min INTEGER DEFAULT 60,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.golden_path_exercises (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    routine_id UUID REFERENCES public.golden_path_routines(id) ON DELETE CASCADE,
    exercise_id UUID REFERENCES public.exercises(id) ON DELETE CASCADE,
    order_index INTEGER NOT NULL,
    target_sets INTEGER NOT NULL DEFAULT 3,
    target_reps_min INTEGER NOT NULL DEFAULT 8,
    target_reps_max INTEGER NOT NULL DEFAULT 12,
    target_rpe NUMERIC(3,1) DEFAULT 8.0,
    target_weight_kg NUMERIC(6,2),
    rest_seconds INTEGER DEFAULT 90,
    tempo TEXT DEFAULT '3-0-1-0'
);

-- 4. ANTRENMAN OTURUMLARI VE SET LOGLARI
CREATE TABLE IF NOT EXISTS public.workout_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    routine_id UUID REFERENCES public.golden_path_routines(id) ON DELETE SET NULL,
    session_title TEXT NOT NULL,
    started_at TIMESTAMPTZ DEFAULT now(),
    completed_at TIMESTAMPTZ,
    duration_seconds INTEGER DEFAULT 0,
    total_volume_kg NUMERIC(10,2) DEFAULT 0,
    cns_strain_score INTEGER DEFAULT 5,
    session_rating INTEGER,
    user_notes TEXT,
    status TEXT DEFAULT 'in_progress' CHECK (status IN ('in_progress', 'completed', 'abandoned')),
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.workout_set_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID REFERENCES public.workout_sessions(id) ON DELETE CASCADE,
    exercise_id UUID REFERENCES public.exercises(id) ON DELETE CASCADE,
    set_number INTEGER NOT NULL,
    weight_kg NUMERIC(6,2) NOT NULL,
    reps_completed INTEGER NOT NULL,
    rpe_achieved NUMERIC(3,1) DEFAULT 8.0,
    is_warmup BOOLEAN DEFAULT false,
    is_completed BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 5. TWINFIT AI KOÇLUK VE RAPORLAR
CREATE TABLE IF NOT EXISTS public.ai_coach_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    message_role TEXT CHECK (message_role IN ('user', 'assistant', 'system')),
    content TEXT NOT NULL,
    context_snapshot JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.weekly_twin_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    week_start DATE NOT NULL,
    week_end DATE NOT NULL,
    hypertrophy_score NUMERIC(5,2) DEFAULT 85.0,
    recovery_efficiency_score NUMERIC(5,2) DEFAULT 90.0,
    volume_progression_pct NUMERIC(5,2) DEFAULT 4.5,
    cns_fatigue_index NUMERIC(5,2) DEFAULT 32.0,
    ai_summary TEXT,
    actionable_recommendations JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 6. GÜNLÜK KALORİ & SU LOGLARI (DASHBOARD SYNC)
CREATE TABLE IF NOT EXISTS public.daily_nutrition_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    log_date DATE NOT NULL DEFAULT CURRENT_DATE,
    calories_consumed INTEGER DEFAULT 0,
    protein_g NUMERIC(5,1) DEFAULT 0,
    carb_g NUMERIC(5,1) DEFAULT 0,
    fat_g NUMERIC(5,1) DEFAULT 0,
    water_ml INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(user_id, log_date)
);

-- RLS (ROW LEVEL SECURITY) POLICIES
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.golden_path_routines ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.golden_path_exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workout_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workout_set_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_coach_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.weekly_twin_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.daily_nutrition_logs ENABLE ROW LEVEL SECURITY;

-- Profiles
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
CREATE POLICY "Users can view own profile" ON public.profiles FOR SELECT USING (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);

DROP POLICY IF EXISTS "Users can insert own profile" ON public.profiles;
CREATE POLICY "Users can insert own profile" ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- Exercises: Public read for all
DROP POLICY IF EXISTS "Allow public read on exercises" ON public.exercises;
CREATE POLICY "Allow public read on exercises" ON public.exercises FOR SELECT TO public USING (true);

DROP POLICY IF EXISTS "Allow service role all on exercises" ON public.exercises;
CREATE POLICY "Allow service role all on exercises" ON public.exercises FOR ALL TO service_role USING (true);

-- Golden Path Routines & Exercises
DROP POLICY IF EXISTS "Users manage own routines" ON public.golden_path_routines;
CREATE POLICY "Users manage own routines" ON public.golden_path_routines FOR ALL USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users manage own routine exercises" ON public.golden_path_exercises;
CREATE POLICY "Users manage own routine exercises" ON public.golden_path_exercises FOR ALL USING (
    EXISTS (
        SELECT 1 FROM public.golden_path_routines r 
        WHERE r.id = golden_path_exercises.routine_id AND r.user_id = auth.uid()
    )
);

-- Workout Sessions & Set Logs
DROP POLICY IF EXISTS "Users manage own sessions" ON public.workout_sessions;
CREATE POLICY "Users manage own sessions" ON public.workout_sessions FOR ALL USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users manage own set logs" ON public.workout_set_logs;
CREATE POLICY "Users manage own set logs" ON public.workout_set_logs FOR ALL USING (
    EXISTS (
        SELECT 1 FROM public.workout_sessions s 
        WHERE s.id = workout_set_logs.session_id AND s.user_id = auth.uid()
    )
);

-- AI Coach & Weekly Reports
DROP POLICY IF EXISTS "Users manage own ai chats" ON public.ai_coach_sessions;
CREATE POLICY "Users manage own ai chats" ON public.ai_coach_sessions FOR ALL USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users view own reports" ON public.weekly_twin_reports;
CREATE POLICY "Users view own reports" ON public.weekly_twin_reports FOR ALL USING (auth.uid() = user_id);

-- Nutrition Logs
DROP POLICY IF EXISTS "Users manage own nutrition" ON public.daily_nutrition_logs;
CREATE POLICY "Users manage own nutrition" ON public.daily_nutrition_logs FOR ALL USING (auth.uid() = user_id);

-- SEED BİYOMEKANİK EGZERSİZ VERİLERİ
INSERT INTO public.exercises (name, turkish_name, target_muscle, synergist_muscles, cns_load_score, sfr_rating, joint_stress_index, biomechanical_notes, execution_cues, equipment)
VALUES
(
    'Incline Dumbbell Bench Press',
    'Eğimli Dambıl Göğüs Presi',
    'Göğüs (Üst Göğüs)',
    ARRAY['Ön Omuz', 'Triceps'],
    5,
    'elite',
    '{"shoulder": 3, "lower_back": 1, "knee": 0, "elbow": 2}'::jsonb,
    '30 derece açı klaviküler lifleri maksimum uyarırken ön omuz stresini minimumda tutar. Dambıl bağımsız hareket açıklığı sunar.',
    ARRAY['Sehpaya 30 derece açı verin', 'Dirsekleri gövdeye 45-60 derece açıyla tutun', 'En altta göğüs kasını 1 saniye gerdirin', 'Tepe noktada dambılları birbirine çarpmayın'],
    'Dumbbell'
),
(
    'Cable Lateral Raise',
    'Kablo Yan Omuz Açış',
    'Yan Omuz (Lateral Deltoid)',
    ARRAY['Trapez (Üst)'],
    2,
    'elite',
    '{"shoulder": 1, "lower_back": 0, "knee": 0, "elbow": 1}'::jsonb,
    'Kablo kas boyu boyunca sabit gerilim sağlar. Dambıl açışa kıyasla SFR skoru en üst seviyedir.',
    ARRAY['Makarayı diz veya bilek hizasına ayarlayın', 'Hareketi dirseklerle yukarı ve dışarı doğru yönlendirin', 'Tepe noktada 0.5 saniye izometrik kasılma sağlayın'],
    'Cable'
),
(
    'Chest-Supported T-Bar Row',
    'Göğüs Destekli T-Bar Row',
    'Sırt (Orta Sırt & Kanat)',
    ARRAY['Biceps', 'Arka Omuz', 'Brakiyalis'],
    4,
    'high',
    '{"shoulder": 2, "lower_back": 1, "knee": 0, "elbow": 2}'::jsonb,
    'Göğüs desteği bel (lumbar) stresini sıfırlar, böylece CNS tükenmeden sırt kası mutlak tükenişe götürülebilir.',
    ARRAY['Göğsü pede sabitleyin, omurgayı nötr tutun', 'Dirsekleri geriye ve kalçaya doğru çekin', 'Skapulayı (kürek kemiklerini) tam retraksiyona getirin'],
    'Machine'
),
(
    'Barbell Squat',
    'Barbell Squat (High Bar)',
    'Ön Bacak (Quadriceps)',
    ARRAY['Gluteus', 'Adductor', 'Erector Spinae'],
    9,
    'medium',
    '{"shoulder": 1, "lower_back": 6, "knee": 5, "elbow": 1}'::jsonb,
    'Yüksek CNS yorgunluğu yaratır. Uzun femura sahip sporcular için topuk yükseltmesi ve diz stabilitesi kritiktir.',
    ARRAY['Barı trapez üzerine oturtun', 'Dizleri ayak parmakları yönünde açarak çömelin', 'Paralel veya hemen altına inip patlayıcı kalkın'],
    'Barbell'
),
(
    'Romanian Deadlift (Dumbbell/Barbell)',
    'Rumen Deadlift (RDL)',
    'Arka Bacak (Hamstrings & Glute)',
    ARRAY['Erector Spinae', 'Trapez'],
    7,
    'high',
    '{"shoulder": 1, "lower_back": 5, "knee": 2, "elbow": 1}'::jsonb,
    'Hamstring kasının uzama (eccentric stretch) evresinde hipertrofi sinyalini maksimize eder.',
    ARRAY['Dizleri hafif bükük kilitleyin', 'Kalçayı geriye doğru itin (Hinge hareketi)', 'Barı bacaklara yakın kaydırarak hamstring gerilimini hissedin'],
    'Barbell'
),
(
    'Seated Leg Curl',
    'Oturarak Bacak Kıvırma',
    'Arka Bacak (Hamstrings)',
    ARRAY['Gastrocnemius'],
    2,
    'elite',
    '{"shoulder": 0, "lower_back": 0, "knee": 2, "elbow": 0}'::jsonb,
    'Oturur pozisyonda kalça fleksiyonda olduğu için hamstring kası anatomik olarak daha uzun pozisyonda uyarılır (Yüksek SFR).',
    ARRAY['Uyluk pedini dizlerin hemen üzerine sıkıca kilitleyin', 'Gövdeyi hafifçe öne eğerek hamstring gerginliğini artırın', 'Kontrollü 3 saniyede bırakın'],
    'Machine'
),
(
    'Lat Pulldown (Neutral Grip)',
    'Lat Pulldown (Nötr Tutuş)',
    'Kanat (Latissimus Dorsi)',
    ARRAY['Biceps', 'Arka Omuz', 'Teres Major'],
    4,
    'high',
    '{"shoulder": 2, "lower_back": 1, "knee": 0, "elbow": 2}'::jsonb,
    'Nötr omuz hizası tutuş, lat liflerinin anatomik yönelimine tam uyum sağlar.',
    ARRAY['Göğsü yukarı kaldırın', 'Dirsekleri yan kaburgalara doğru indirin', 'Yukarıda lat kasının tam uzamasına izin verin'],
    'Cable'
),
(
    'Overhead Cable Triceps Extension',
    'Kafa Üstü Kablo Triceps İtiş',
    'Arka Kol (Triceps Uzun Baş)',
    ARRAY['Anconeus'],
    2,
    'elite',
    '{"shoulder": 2, "lower_back": 0, "knee": 0, "elbow": 2}'::jsonb,
    'Triceps uzun başı omuz fleksiyondayken tam gerilime girer ve maksimum hipertrofi sağlar.',
    ARRAY['Halatı arkadan öne doğru baş üzerinden itin', 'Dirsekleri sabit tutarak sadece ön kolları açın', 'En altta triceps kasını gerdirin'],
    'Cable'
),
(
    'Incline Cable Biceps Curl',
    'Eğimli Sehpa Kablo Biceps Curl',
    'Ön Kol (Biceps Brachii)',
    ARRAY['Brachialis', 'Brachioradialis'],
    2,
    'elite',
    '{"shoulder": 1, "lower_back": 0, "knee": 0, "elbow": 2}'::jsonb,
    'Kollar gövdenin gerisinde kalarak biceps uzun başı üzerinde derin pasif gerilim oluşturur.',
    ARRAY['Sehpaya 60 derece açı verin', 'Dirsekleri geride sabitleyin', 'Sadece ön kolları kaldırarak tepe noktada sıkın'],
    'Cable'
),
(
    'Bulgarian Split Squat',
    'Bulgar Bölünmüş Squat',
    'Ön Bacak & Glute',
    ARRAY['Hamstrings', 'Adductor'],
    6,
    'high',
    '{"shoulder": 0, "lower_back": 2, "knee": 4, "elbow": 0}'::jsonb,
    'Unilateral yükleme sayesinde omurga basısı düşüktür, bacak kası aktivasyonu ise çok yüksektir.',
    ARRAY['Arka ayağı sehpaya yerleştirin', 'Ön ayak tabanına ağırlığı vererek çömelin', 'Dizin içe kaçmasına izin vermeyin'],
    'Dumbbell'
),
(
    'Standing Calf Raise',
    'Ayakta Kalf Kaldırma',
    'Kalf (Gastrocnemius & Soleus)',
    ARRAY['Tibialis Posterior'],
    3,
    'high',
    '{"shoulder": 0, "lower_back": 1, "knee": 1, "elbow": 0}'::jsonb,
    'Dizler tam düzken gastrocnemius maksimum mekanik gerilim üretir.',
    ARRAY['Topukları olabildiğince aşağı sarkıtıp 2 saniye bekleyin', 'Parmak uçlarında tepeye kadar yükselip 1 saniye sıkın'],
    'Machine'
),
(
    'Pec Deck Fly (Machine)',
    'Makine Göğüs Sıkıştırma (Pec Deck)',
    'Göğüs (Sternal Baş)',
    ARRAY['Ön Omuz'],
    3,
    'high',
    '{"shoulder": 3, "lower_back": 0, "knee": 0, "elbow": 1}'::jsonb,
    'Tepe kasılmada direncin düşmediği, göğsü izole eden mükemmel bir tamamlama hareketidir.',
    ARRAY['Kolları hafif bükük sabitleyin', 'Dirsekleri önde birleştirmeye odaklanın', 'Omuzları geriye çekik tutun'],
    'Machine'
)
ON CONFLICT DO NOTHING;
