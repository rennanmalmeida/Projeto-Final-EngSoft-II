--
-- Definir uma variável de sessão para o nome do esquema.
-- A variável 'app.schema' será acessível durante toda a sessão.
-- Isso evita a repetição do nome do esquema e facilita a manutenção.
--

SET app.schema = 'public';

--
-- Definir constante para evitar repetição do literal
--
DO $$
DECLARE
  APP_SCHEMA_KEY CONSTANT TEXT := 'app.schema';
BEGIN
  -- Apenas declaração da constante, será usada nas consultas.
END$$;

---

--
-- Consultas para verificar triggers existentes
--

-- Verificar triggers na tabela 'stock_movements'
SELECT 
    t.tgname AS trigger_name,
    c.relname AS table_name,
    t.tgenabled,
    pg_get_triggerdef(t.oid) AS trigger_definition
FROM pg_trigger t
JOIN pg_class c ON t.tgrelid = c.oid
JOIN pg_namespace n ON c.relnamespace = n.oid
WHERE c.relname = 'stock_movements'
  AND n.nspname = current_setting(APP_SCHEMA_KEY)
  AND NOT t.tgisinternal;

---

-- Verificar triggers na tabela 'products'
SELECT 
    t.tgname AS trigger_name,
    c.relname AS table_name,
    t.tgenabled,
    pg_get_triggerdef(t.oid) AS trigger_definition
FROM pg_trigger t
JOIN pg_class c ON t.tgrelid = c.oid
JOIN pg_namespace n ON c.relnamespace = n.oid
WHERE c.relname = 'products'
  AND n.nspname = current_setting(APP_SCHEMA_KEY)
  AND NOT t.tgisinternal;

---

--
-- Consulta para verificar a função de gatilho
--

-- Verificar detalhes da função 'update_product_quantity'
SELECT 
    proname,
    prosrc
FROM pg_proc 
WHERE proname = 'update_product_quantity';

---

--
-- Consulta para verificar a associação entre triggers e a função
--

-- Verificar triggers que usam a função 'update_product_quantity' nas tabelas 'stock_movements' e 'products'
SELECT 
    t.tgname AS trigger_name,
    c.relname AS table_name,
    p.proname AS function_name,
    t.tgenabled
FROM pg_trigger t
JOIN pg_class c ON t.tgrelid = c.oid
JOIN pg_proc p ON t.tgfoid = p.oid
JOIN pg_namespace n ON c.relnamespace = n.oid
WHERE n.nspname = current_setting(APP_SCHEMA_KEY)
  AND c.relname IN ('stock_movements', 'products')
  AND NOT t.tgisinternal
ORDER BY c.relname ASC, t.tgname ASC;
