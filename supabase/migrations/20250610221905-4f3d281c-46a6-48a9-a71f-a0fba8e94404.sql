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

  -- Constantes para chaves JSON
  JSON_KEY_IS_VALID      CONSTANT TEXT := 'isValid';
  JSON_KEY_MESSAGE       CONSTANT TEXT := 'message';
  JSON_KEY_CURRENT_STOCK CONSTANT TEXT := 'currentStock';
  JSON_KEY_PRODUCT_NAME  CONSTANT TEXT := 'productName';
BEGIN
  -- Buscar produto
  SELECT quantity, name INTO current_stock, product_name
  FROM public.products 
  WHERE id = product_id_param;
  
  IF NOT FOUND THEN
    SELECT json_build_object(
      JSON_KEY_IS_VALID, false,
      JSON_KEY_CURRENT_STOCK, 0,
      JSON_KEY_MESSAGE, 'Produto não encontrado'
    ) INTO result;
    RETURN result;
  END IF;
  
  -- Validar saída
  IF type_param = 'out' THEN
    IF current_stock = 0 THEN
      SELECT json_build_object(
        JSON_KEY_IS_VALID, false,
        JSON_KEY_CURRENT_STOCK, current_stock,
        JSON_KEY_MESSAGE, format('Produto "%s" sem estoque disponível', product_name)
      ) INTO result;
      RETURN result;
    END IF;
    
    IF current_stock < quantity_param THEN
      SELECT json_build_object(
        JSON_KEY_IS_VALID, false,
        JSON_KEY_CURRENT_STOCK, current_stock,
        JSON_KEY_MESSAGE, format(
          'Estoque insuficiente para "%s". Disponível: %s, Solicitado: %s', 
          product_name, current_stock, quantity_param
        )
      ) INTO result;
      RETURN result;
    END IF;
  END IF;
  
  -- Validação passou
  SELECT json_build_object(
    JSON_KEY_IS_VALID, true,
    JSON_KEY_CURRENT_STOCK, current_stock,
    JSON_KEY_PRODUCT_NAME, product_name
  ) INTO result;
  
  RETURN result;
END;
$function$;
