// ...imports and component code...

const SupplierForm: React.FC<SupplierFormProps> = ({
  defaultValues,
  onSubmit,
  isLoading = false,
}) => {
  // ...state and handlers...

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      {hasErrors && (
        <Alert variant="destructive">
          <AlertCircle className="h-4 w-4" />
          <AlertDescription>
            Por favor, corrija os erros abaixo antes de continuar.
          </AlertDescription>
        </Alert>
      )}

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className="space-y-4">
          <div className="space-y-2">
            <label htmlFor="supplier-name" className="text-sm font-medium">Nome da Empresa*</label>
            <Input
              id="supplier-name"
              placeholder="Ex: Distribuidora ABC Ltda"
              value={formData.name}
              onChange={(e) => handleChange('name', e.target.value)}
            />
            {errors.name && (
              <p className="text-sm font-medium text-destructive">{errors.name}</p>
            )}
          </div>

          <div className="space-y-2">
            <label htmlFor="supplier-cnpj" className="text-sm font-medium">CNPJ</label>
            <CnpjInput
              id="supplier-cnpj"
              value={formData.cnpj || ""}
              onChange={(value) => handleChange('cnpj', value)}
              placeholder="00.000.000/0000-00"
            />
          </div>

          <div className="space-y-2">
            <label htmlFor="supplier-contactName" className="text-sm font-medium">Nome do Contato</label>
            <Input
              id="supplier-contactName"
              placeholder="Ex: João Silva"
              value={formData.contactName || ""}
              onChange={(e) => handleChange('contactName', e.target.value)}
            />
          </div>

          <div className="space-y-2">
            <label htmlFor="supplier-email" className="text-sm font-medium">Email</label>
            <Input
              id="supplier-email"
              type="email"
              placeholder="contato@empresa.com.br"
              value={formData.email || ""}
              onChange={(e) => handleChange('email', e.target.value)}
            />
            {errors.email && (
              <p className="text-sm font-medium text-destructive">{errors.email}</p>
            )}
          </div>

          <div className="space-y-2">
            <label htmlFor="supplier-phone" className="text-sm font-medium">Telefone</label>
            <PhoneInput
              id="supplier-phone"
              value={formData.phone || ""}
              onChange={(value) => handleChange('phone', value)}
              placeholder="(11) 99999-9999"
            />
          </div>
        </div>

        <div className="space-y-4">
          <div className="space-y-2">
            <label htmlFor="supplier-address" className="text-sm font-medium">Endereço</label>
            <Input
              id="supplier-address"
              placeholder="Rua das Flores, 123 - Centro"
              value={formData.address || ""}
              onChange={(e) => handleChange('address', e.target.value)}
            />
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <label htmlFor="supplier-city" className="text-sm font-medium">Cidade</label>
              <Input
                id="supplier-city"
                placeholder="São Paulo"
                value={formData.city || ""}
                onChange={(e) => handleChange('city', e.target.value)}
              />
            </div>

            <div className="space-y-2">
              <label htmlFor="supplier-state" className="text-sm font-medium">Estado</label>
              <Input
                id="supplier-state"
                placeholder="SP"
                maxLength={2}
                value={formData.state || ""}
                onChange={(e) => handleChange('state', e.target.value.toUpperCase())}
              />
            </div>
          </div>

          <div className="space-y-2">
            <label htmlFor="supplier-zipCode" className="text-sm font-medium">CEP</label>
            <CepInput
              id="supplier-zipCode"
              value={formData.zipCode || ""}
              onChange={(value) => handleChange('zipCode', value)}
              placeholder="00000-000"
            />
          </div>

          <div className="space-y-2">
            <label htmlFor="supplier-notes" className="text-sm font-medium">Observações</label>
            <Textarea
              id="supplier-notes"
              placeholder="Informações adicionais sobre o fornecedor, condições comerciais, etc."
              value={formData.notes || ""}
              onChange={(e) => handleChange('notes', e.target.value)}
              className="min-h-[80px] resize-none"
            />
          </div>
        </div>
      </div>

      <div className="flex justify-end gap-3 pt-6 border-t">
        <Button 
          type="submit" 
          disabled={isSubmitting || isLoading || hasErrors}
          className="min-w-[140px]"
        >
          {(isSubmitting || isLoading) ? (
            <>
              <Loader2 className="h-4 w-4 animate-spin mr-2" />
              Salvando...
            </>
          ) : (
            "Salvar fornecedor"
          )}
        </Button>
      </div>
    </form>
  );
};

export default SupplierForm;
