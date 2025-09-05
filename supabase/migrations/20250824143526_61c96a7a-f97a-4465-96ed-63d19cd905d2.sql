CREATE OR REPLACE FUNCTION public.validate_stock_movement(
  product_id_param uuid, 
  quantity_param integer, 
  type_param text
)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $function$
DECLARE
  current_stock INTEGER;
  product_name TEXT;
  result JSON;
  
  -- Constantes
  PRODUCT_NOT_FOUND_MSG CONSTANT TEXT := 'Produto não encontrado';
  MESSAGE_KEY CONSTANT TEXT := 'message';
BEGIN
  -- Busca do produto
  SELECT quantity, name INTO current_stock, product_name
  FROM public.products 
  WHERE id = product_id_param;
  
  -- Produto não encontrado
  IF NOT FOUND THEN
    SELECT json_build_object(
      'isValid', false,
      MESSAGE_KEY, PRODUCT_NOT_FOUND_MSG
    ) INTO result;
    RETURN result;
  END IF;
  
  -- Validação para saída
  IF type_param = 'out' THEN
    IF current_stock = 0 THEN
      SELECT json_build_object(
        'isValid', false,
        'currentStock', current_stock,
        MESSAGE_KEY, format('Produto "%s" sem estoque disponível', product_name)
      ) INTO result;
      RETURN result;
    END IF;
    
    IF current_stock < quantity_param THEN
      SELECT json_build_object(
        'isValid', false,
        'currentStock', current_stock,
        MESSAGE_KEY, format(
          'Estoque insuficiente para "%s". Disponível: %s, Solicitado: %s', 
          product_name, current_stock, quantity_param
        )
      ) INTO result;
      RETURN result;
    END IF;
  END IF;
  
  -- Validação OK
  SELECT json_build_object(
    'isValid', true, 
    'currentStock', current_stock,
    'productName', product_name
  ) INTO result;
  
  RETURN result;
END;
$function$;
