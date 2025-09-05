-- Função para validar movimentação antes da inserção
CREATE OR REPLACE FUNCTION public.validate_stock_movement(
  product_id_param uuid,
  quantity_param integer,
  type_param text
)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  current_stock INTEGER;
  product_name TEXT;
  result JSON;

  -- Constante para a chave JSON
  JSON_KEY_CURRENT_STOCK CONSTANT TEXT := 'currentStock';
BEGIN
  -- Buscar produto
  SELECT quantity, name INTO current_stock, product_name
  FROM public.products 
  WHERE id = product_id_param;
  
  IF NOT FOUND THEN
    SELECT json_build_object(
      'isValid', false,
      JSON_KEY_CURRENT_STOCK, 0,
      'message', 'Produto não encontrado'
    ) INTO result;
    RETURN result;
  END IF;
  
  -- Validar saída
  IF type_param = 'out' THEN
    IF current_stock = 0 THEN
      SELECT json_build_object(
        'isValid', false,
        JSON_KEY_CURRENT_STOCK, current_stock,
        'message', format('Produto "%s" sem estoque disponível', product_name)
      ) INTO result;
      RETURN result;
    END IF;
    
    IF current_stock < quantity_param THEN
      SELECT json_build_object(
        'isValid', false,
        JSON_KEY_CURRENT_STOCK, current_stock,
        'message', format('Estoque insuficiente para "%s". Disponível: %s, Solicitado: %s', 
          product_name, current_stock, quantity_param)
      ) INTO result;
      RETURN result;
    END IF;
  END IF;
  
  -- Validação passou
  SELECT json_build_object(
    'isValid', true,
    JSON_KEY_CURRENT_STOCK, current_stock,
    'productName', product_name
  ) INTO result;
  
  RETURN result;
END;
$function$;
