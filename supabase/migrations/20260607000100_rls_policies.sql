-- Enable RLS on all public tables
ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.organization_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.properties ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.units ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tenants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.rent_invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payout_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.maintenance_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.documents ENABLE ROW LEVEL SECURITY;

-- Helper to extract organization_id from jwt user_metadata
CREATE OR REPLACE FUNCTION public.get_auth_org_id()
RETURNS UUID AS $$
  SELECT COALESCE(
    (current_setting('request.jwt.claims', true)::jsonb -> 'user_metadata' ->> 'organization_id')::UUID,
    NULL
  );
$$ LANGUAGE sql STABLE SECURITY DEFINER;

-- Organization-scoped RLS policies (Restricts data to only match active org_id in session metadata)
CREATE POLICY org_isolation_policy ON public.properties
  AS RESTRICTIVE
  USING (organization_id = public.get_auth_org_id())
  WITH CHECK (organization_id = public.get_auth_org_id());

CREATE POLICY org_isolation_policy ON public.units
  AS RESTRICTIVE
  USING (organization_id = public.get_auth_org_id())
  WITH CHECK (organization_id = public.get_auth_org_id());

CREATE POLICY org_isolation_policy ON public.tenants
  AS RESTRICTIVE
  USING (organization_id = public.get_auth_org_id())
  WITH CHECK (organization_id = public.get_auth_org_id());

CREATE POLICY org_isolation_policy ON public.payments
  AS RESTRICTIVE
  USING (organization_id = public.get_auth_org_id())
  WITH CHECK (organization_id = public.get_auth_org_id());

CREATE POLICY org_isolation_policy ON public.payout_accounts
  AS RESTRICTIVE
  USING (organization_id = public.get_auth_org_id())
  WITH CHECK (organization_id = public.get_auth_org_id());

CREATE POLICY org_isolation_policy ON public.payouts
  AS RESTRICTIVE
  USING (organization_id = public.get_auth_org_id())
  WITH CHECK (organization_id = public.get_auth_org_id());

CREATE POLICY org_isolation_policy ON public.rent_invoices
  AS RESTRICTIVE
  USING (organization_id = public.get_auth_org_id())
  WITH CHECK (organization_id = public.get_auth_org_id());

CREATE POLICY org_isolation_policy ON public.maintenance_requests
  AS RESTRICTIVE
  USING (organization_id = public.get_auth_org_id())
  WITH CHECK (organization_id = public.get_auth_org_id());

CREATE POLICY org_isolation_policy ON public.documents
  AS RESTRICTIVE
  USING (organization_id = public.get_auth_org_id())
  WITH CHECK (organization_id = public.get_auth_org_id());
