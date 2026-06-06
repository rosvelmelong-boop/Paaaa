-- 1. Multi-Tenant Identity
CREATE TABLE public.organizations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  phone_number TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE public.organization_members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID REFERENCES public.organizations(id) ON DELETE CASCADE,
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('app_admin', 'landlord_admin', 'agency_admin', 'staff', 'property_owner', 'tenant', 'caretaker')),
  permissions JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE (organization_id, user_id)
);

-- 2. Subscriptions
CREATE TABLE public.subscription_plans (
  id TEXT PRIMARY KEY, -- 'free', 'starter', 'pro', 'agence_pro'
  name TEXT NOT NULL,
  monthly_price INT NOT NULL DEFAULT 0, -- in XAF
  rent_commission_percent NUMERIC(5,2) DEFAULT 0,
  manual_payment_limit INT DEFAULT 0, -- 0 means unlimited
  flutterwave_rent_collection_enabled BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE public.subscriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID REFERENCES public.organizations(id) ON DELETE CASCADE,
  plan_id TEXT REFERENCES public.subscription_plans(id),
  status TEXT NOT NULL CHECK (status IN ('active', 'past_due', 'canceled')),
  current_period_start TIMESTAMPTZ NOT NULL,
  current_period_end TIMESTAMPTZ NOT NULL,
  flutterwave_ref TEXT UNIQUE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Populate default subscription plans
INSERT INTO public.subscription_plans (id, name, monthly_price, rent_commission_percent, manual_payment_limit, flutterwave_rent_collection_enabled) VALUES
('free', 'Free Plan', 0, 0.00, 0, false),
('starter', 'Starter Plan', 0, 6.00, 10, true),
('pro', 'Pro Plan', 0, 8.00, 25, true),
('agence_pro', 'Agence Pro Plan', 0, 10.00, 0, true)
ON CONFLICT (id) DO NOTHING;

-- 3. Properties & Accommodations
CREATE TABLE public.properties (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID REFERENCES public.organizations(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  address TEXT,
  city TEXT,
  country TEXT DEFAULT 'Cameroon',
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  google_place_id TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE public.units (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID REFERENCES public.organizations(id) ON DELETE CASCADE,
  property_id UUID REFERENCES public.properties(id) ON DELETE CASCADE,
  name TEXT NOT NULL, -- e.g. "Apartment A1"
  rent_amount INT NOT NULL DEFAULT 0, -- in XAF
  status TEXT NOT NULL DEFAULT 'vacant' CHECK (status IN ('occupied', 'vacant', 'maintenance')),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 4. Tenants
CREATE TABLE public.tenants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID REFERENCES public.organizations(id) ON DELETE CASCADE,
  unit_id UUID REFERENCES public.units(id) ON DELETE SET NULL,
  user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
  full_name TEXT NOT NULL,
  phone_number TEXT NOT NULL,
  email TEXT,
  lease_start_date DATE NOT NULL,
  lease_end_date DATE,
  portal_token_hash TEXT,
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'evicted', 'notice', 'past')),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 5. Invoices & Payments
CREATE TABLE public.rent_invoices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID REFERENCES public.organizations(id) ON DELETE CASCADE,
  tenant_id UUID REFERENCES public.tenants(id) ON DELETE CASCADE,
  unit_id UUID REFERENCES public.units(id) ON DELETE CASCADE,
  amount INT NOT NULL,
  due_date DATE NOT NULL,
  status TEXT NOT NULL DEFAULT 'unpaid' CHECK (status IN ('paid', 'unpaid', 'partially_paid', 'overdue', 'cancelled')),
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE public.payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID REFERENCES public.organizations(id) ON DELETE CASCADE,
  invoice_id UUID REFERENCES public.rent_invoices(id) ON DELETE SET NULL,
  payer_type VARCHAR(50) CHECK (payer_type IN ('landlord', 'tenant', 'agency')),
  payment_type VARCHAR(50) CHECK (payment_type IN ('subscription', 'rent', 'refund')),
  amount INT NOT NULL,
  currency VARCHAR(10) DEFAULT 'XAF',
  
  -- Commission Splits
  rent_amount INT DEFAULT 0,
  tenant_total_paid INT DEFAULT 0,
  landlord_gross_amount INT DEFAULT 0,
  propveil_commission_percent NUMERIC(5,2) DEFAULT 0,
  propveil_commission_amount INT DEFAULT 0,
  withdrawal_charge_amount INT DEFAULT 0,
  flutterwave_processing_fee_amount INT DEFAULT 0,
  landlord_net_payout_amount INT DEFAULT 0,
  fee_policy VARCHAR(50) DEFAULT 'landlord_commission_tenant_withdrawal',
  verification_type VARCHAR(50) DEFAULT 'flutterwave_verified' CHECK (verification_type IN ('flutterwave_verified', 'manual_landlord_recorded', 'manual_admin_verified')),
  is_locked BOOLEAN DEFAULT FALSE,
  
  tx_ref VARCHAR(150) UNIQUE NOT NULL,
  flutterwave_transaction_id VARCHAR(150),
  status VARCHAR(50) DEFAULT 'pending',
  verified_at TIMESTAMPTZ,
  raw_provider_response JSONB,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 6. Payout Accounts & Transfers
CREATE TABLE public.payout_accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID REFERENCES public.organizations(id) ON DELETE CASCADE,
  payout_method TEXT NOT NULL CHECK (payout_method IN ('mobile_money', 'bank_transfer')),
  provider TEXT NOT NULL, -- MTN, Orange, UBA, Express Union
  account_number TEXT NOT NULL,
  account_name TEXT NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE public.payouts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID REFERENCES public.organizations(id) ON DELETE CASCADE,
  payout_account_id UUID REFERENCES public.payout_accounts(id) ON DELETE RESTRICT,
  amount INT NOT NULL,
  currency VARCHAR(10) DEFAULT 'XAF',
  flutterwave_transfer_id TEXT UNIQUE,
  status TEXT NOT NULL DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 7. Supporting Elements (Maintenance & Documents)
CREATE TABLE public.maintenance_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID REFERENCES public.organizations(id) ON DELETE CASCADE,
  unit_id UUID REFERENCES public.units(id) ON DELETE CASCADE,
  tenant_id UUID REFERENCES public.tenants(id) ON DELETE SET NULL,
  title TEXT NOT NULL,
  description TEXT,
  status TEXT NOT NULL DEFAULT 'new' CHECK (status IN ('new', 'assigned', 'in_progress', 'completed', 'cancelled')),
  ai_summary TEXT,
  ai_suggested_action TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE public.documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID REFERENCES public.organizations(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  file_path TEXT NOT NULL, -- Supabase storage path
  doc_type TEXT CHECK (doc_type IN ('lease_agreement', 'id_proof', 'receipt', 'property_photo')),
  created_at TIMESTAMPTZ DEFAULT now()
);
