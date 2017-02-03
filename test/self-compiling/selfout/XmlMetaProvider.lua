-- Generated by CSharp.lua Compiler 1.0.0.0
local System = System;
local MicrosoftCodeAnalysis = Microsoft.CodeAnalysis;
local SystemIO = System.IO;
local SystemXmlSerialization = System.Xml.Serialization;
local CSharpLua;
local CSharpLuaLuaAst;
local CSharpLuaXmlMetaProvider;
local CSharpLuaXmlMetaProviderXmlMetaModel;
System.usingDeclare(function (global) 
    CSharpLua = global.CSharpLua;
    CSharpLuaLuaAst = CSharpLua.LuaAst;
    CSharpLuaXmlMetaProvider = CSharpLua.XmlMetaProvider;
    CSharpLuaXmlMetaProviderXmlMetaModel = CSharpLua.XmlMetaProvider.XmlMetaModel;
end);
System.namespace("CSharpLua", function (namespace) 
    namespace.class("XmlMetaProvider", function (namespace) 
        namespace.class("XmlMetaModel", function (namespace) 
            namespace.class("TemplateModel", function (namespace) 
                return {};
            end);
            namespace.class("PropertyModel", function (namespace) 
                return {
                    IsAutoField = false
                };
            end);
            namespace.class("FieldModel", function (namespace) 
                return {};
            end);
            namespace.class("ArgumentModel", function (namespace) 
                return {};
            end);
            namespace.class("MethodModel", function (namespace) 
                local __ctor__;
                __ctor__ = function (this) 
                    this.ArgCount = - 1;
                    this.GenericArgCount = - 1;
                end;
                return {
                    __ctor__ = __ctor__
                };
            end);
            namespace.class("ClassModel", function (namespace) 
                return {};
            end);
            namespace.class("NamespaceModel", function (namespace) 
                return {};
            end);
            return {
                __attributes__ = function () 
                    return {
                        class = {
                            SystemXmlSerialization.XmlRootAttribute("assembly")
                        }
                    };
                end
            };
        end);
        namespace.class("MethodMetaInfo", function (namespace) 
            local Add, CheckIsSingleModel, IsTypeMatch, IsMethodMatch, GetName, GetCodeTemplate, GetMetaInfo, __ctor__;
            Add = function (this, model) 
                this.models_:Add(model);
                CheckIsSingleModel(this);
            end;
            CheckIsSingleModel = function (this) 
                local isSingle = false;
                if #this.models_ == 1 then
                    local model = CSharpLua.Utility.First(this.models_, CSharpLuaXmlMetaProviderXmlMetaModel.MethodModel);
                    if model.ArgCount == - 1 and model.Args == nil and model.RetType == nil and model.GenericArgCount == - 1 then
                        isSingle = true;
                    end
                end
                this.isSingleModel_ = isSingle;
            end;
            IsTypeMatch = function (this, symbol, typeString) 
                local typeSymbol = System.cast(MicrosoftCodeAnalysis.INamedTypeSymbol, symbol:getOriginalDefinition());
                local namespaceName = typeSymbol:getContainingNamespace():ToString();
                local name;
                if typeSymbol:getTypeArguments():getLength() == 0 then
                    name = ("{0}.{1}"):Format(namespaceName, symbol:getName());
                else
                    name = ("{0}.{1}^{2}"):Format(namespaceName, symbol:getName(), typeSymbol:getTypeArguments():getLength());
                end
                return name == typeString;
            end;
            IsMethodMatch = function (this, model, symbol) 
                if model.name ~= symbol:getName() then
                    return false;
                end

                if model.ArgCount ~= - 1 then
                    if symbol:getParameters():getLength() ~= model.ArgCount then
                        return false;
                    end
                end

                if model.GenericArgCount ~= - 1 then
                    if symbol:getTypeArguments():getLength() ~= model.GenericArgCount then
                        return false;
                    end
                end

                if not System.String.IsNullOrEmpty(model.RetType) then
                    if not IsTypeMatch(this, symbol:getReturnType(), model.RetType) then
                        return false;
                    end
                end

                if model.Args ~= nil then
                    if symbol:getParameters():getLength() ~= #model.Args then
                        return false;
                    end

                    local index = 0;
                    for _, parameter in System.each(symbol:getParameters()) do
                        local parameterModel = model.Args:get(index);
                        if not IsTypeMatch(this, parameter:getType(), parameterModel.type) then
                            return false;
                        end
                        index = index + 1;
                    end
                end

                return true;
            end;
            GetName = function (this, symbol) 
                if this.isSingleModel_ then
                    return CSharpLua.Utility.First(this.models_, CSharpLuaXmlMetaProviderXmlMetaModel.MethodModel).Name;
                end

                local methodModel = this.models_:Find(function (i) return IsMethodMatch(this, i, symbol); end);
                local default = methodModel;
                if default ~= nil then
                    default = default.Name;
                end
                return default;
            end;
            GetCodeTemplate = function (this, symbol) 
                if this.isSingleModel_ then
                    return CSharpLua.Utility.First(this.models_, CSharpLuaXmlMetaProviderXmlMetaModel.MethodModel).Template;
                end

                local methodModel = this.models_:Find(function (i) return IsMethodMatch(this, i, symbol); end);
                local default = methodModel;
                if default ~= nil then
                    default = default.Template;
                end
                return default;
            end;
            GetMetaInfo = function (this, symbol, type) 
                repeat
                    local default = type;
                    if default == 0 --[[MethodMetaType.Name]] then
                        do
                            return GetName(this, symbol);
                        end
                    elseif default == 1 --[[MethodMetaType.CodeTemplate]] then
                        do
                            return GetCodeTemplate(this, symbol);
                        end
                    else
                        do
                            System.throw(System.InvalidOperationException());
                        end
                    end
                until 1;
            end;
            __ctor__ = function (this) 
                this.models_ = System.List(CSharpLuaXmlMetaProviderXmlMetaModel.MethodModel)();
            end;
            return {
                isSingleModel_ = false, 
                Add = Add, 
                GetMetaInfo = GetMetaInfo, 
                __ctor__ = __ctor__
            };
        end);
        namespace.class("TypeMetaInfo", function (namespace) 
            local getModel, Field, Property, Method, GetFieldModel, GetPropertyModel, GetMethodMetaInfo, __init__, 
            __ctor__;
            getModel = function (this) 
                return this.model_;
            end;
            Field = function (this) 
                if this.model_.Fields ~= nil then
                    for _, fieldModel in System.each(this.model_.Fields) do
                        if System.String.IsNullOrEmpty(fieldModel.name) then
                            System.throw(System.ArgumentException(("type [{0}] has a field name is empty"):Format(this.model_.name)));
                        end

                        if this.fields_:ContainsKey(fieldModel.name) then
                            System.throw(System.ArgumentException(("type [{0}]'s field [{1}] is already exists"):Format(this.model_.name, fieldModel.name)));
                        end
                        this.fields_:Add(fieldModel.name, fieldModel);
                    end
                end
            end;
            Property = function (this) 
                if this.model_.Propertys ~= nil then
                    for _, propertyModel in System.each(this.model_.Propertys) do
                        if System.String.IsNullOrEmpty(propertyModel.name) then
                            System.throw(System.ArgumentException(("type [{0}] has a property name is empty"):Format(this.model_.name)));
                        end

                        if this.fields_:ContainsKey(propertyModel.name) then
                            System.throw(System.ArgumentException(("type [{0}]'s property [{1}] is already exists"):Format(this.model_.name, propertyModel.name)));
                        end
                        this.propertys_:Add(propertyModel.name, propertyModel);
                    end
                end
            end;
            Method = function (this) 
                if this.model_.Methods ~= nil then
                    for _, methodModel in System.each(this.model_.Methods) do
                        if System.String.IsNullOrEmpty(methodModel.name) then
                            System.throw(System.ArgumentException(("type [{0}] has a method name is empty"):Format(this.model_.name)));
                        end

                        local info = CSharpLua.Utility.GetOrDefault1(this.methods_, methodModel.name, nil, System.String, CSharpLuaXmlMetaProvider.MethodMetaInfo);
                        if info == nil then
                            info = CSharpLuaXmlMetaProvider.MethodMetaInfo();
                            this.methods_:Add(methodModel.name, info);
                        end
                        info:Add(methodModel);
                    end
                end
            end;
            GetFieldModel = function (this, name) 
                return CSharpLua.Utility.GetOrDefault1(this.fields_, name, nil, System.String, CSharpLuaXmlMetaProviderXmlMetaModel.FieldModel);
            end;
            GetPropertyModel = function (this, name) 
                return CSharpLua.Utility.GetOrDefault1(this.propertys_, name, nil, System.String, CSharpLuaXmlMetaProviderXmlMetaModel.PropertyModel);
            end;
            GetMethodMetaInfo = function (this, name) 
                return CSharpLua.Utility.GetOrDefault1(this.methods_, name, nil, System.String, CSharpLuaXmlMetaProvider.MethodMetaInfo);
            end;
            __init__ = function (this) 
                this.fields_ = System.Dictionary(System.String, CSharpLuaXmlMetaProviderXmlMetaModel.FieldModel)();
                this.propertys_ = System.Dictionary(System.String, CSharpLuaXmlMetaProviderXmlMetaModel.PropertyModel)();
                this.methods_ = System.Dictionary(System.String, CSharpLuaXmlMetaProvider.MethodMetaInfo)();
            end;
            __ctor__ = function (this, model) 
                __init__(this);
                this.model_ = model;
                Field(this);
                Property(this);
                Method(this);
            end;
            return {
                getModel = getModel, 
                GetFieldModel = GetFieldModel, 
                GetPropertyModel = GetPropertyModel, 
                GetMethodMetaInfo = GetMethodMetaInfo, 
                __ctor__ = __ctor__
            };
        end);
        local LoadNamespace, LoadType, GetNamespaceMapName, GetTypeName, MayHaveCodeMeta, GetTypeShortString, GetTypeShortName, GetTypeMetaInfo, 
        IsPropertyField, GetFieldCodeTemplate, GetProertyCodeTemplate, GetInternalMethodMetaInfo, GetMethodMetaInfo, GetMethodMapName, GetMethodCodeTemplate, __init__, 
        __ctor__;
        LoadNamespace = function (this, model) 
            local namespaceName = model.name;
            if System.String.IsNullOrEmpty(namespaceName) then
                System.throw(System.ArgumentException("namespace's name is empty"));
            end

            if not System.String.IsNullOrEmpty(model.Name) then
                if this.namespaceNameMaps_:ContainsKey(namespaceName) then
                    System.throw(System.ArgumentException(("namespace [{0}] is already has"):Format(namespaceName)));
                end
                this.namespaceNameMaps_:Add(namespaceName, model.Name);
            end

            if model.Classes ~= nil then
                local default;
                if not System.String.IsNullOrEmpty(model.Name) then
                    default = model.Name;
                else
                    default = namespaceName;
                end
                local name = default;
                LoadType(this, name, model.Classes);
            end
        end;
        LoadType = function (this, namespaceName, classes) 
            for _, classModel in System.each(classes) do
                local className = classModel.name;
                if System.String.IsNullOrEmpty(className) then
                    System.throw(System.ArgumentException(("namespace [{0}] has a class's name is empty"):Format(namespaceName)));
                end

                local classesfullName = (namespaceName or "") .. '.' .. (className or "");
                classesfullName = classesfullName:Replace(94 --[['^']], 95 --[['_']]);
                if this.typeMetas_:ContainsKey(classesfullName) then
                    System.throw(System.ArgumentException(("type [{0}] is already has"):Format(classesfullName)));
                end
                local info = CSharpLuaXmlMetaProvider.TypeMetaInfo(classModel);
                this.typeMetas_:Add(classesfullName, info);
            end
        end;
        GetNamespaceMapName = function (this, symbol) 
            if symbol:getIsGlobalNamespace() then
                return "";
            else
                local name = symbol:ToString();
                return CSharpLua.Utility.GetOrDefault1(this.namespaceNameMaps_, name, name, System.String, System.String);
            end
        end;
        GetTypeName = function (this, symbol, transfor, node) 
            assert(symbol ~= nil);
            if symbol:getKind() == 17 --[[SymbolKind.TypeParameter]] then
                return CSharpLuaLuaAst.LuaIdentifierNameSyntax:new(1, symbol:getName());
            end

            if symbol:getKind() == 1 --[[SymbolKind.ArrayType]] then
                local arrayType = System.cast(MicrosoftCodeAnalysis.IArrayTypeSymbol, symbol);
                local elementTypeExpression = GetTypeName(this, arrayType:getElementType(), transfor, node);
                local default;
                if arrayType:getRank() == 1 then
                    default = CSharpLuaLuaAst.LuaIdentifierNameSyntax.Array;
                else
                    default = CSharpLuaLuaAst.LuaIdentifierNameSyntax.MultiArray;
                end
                return CSharpLuaLuaAst.LuaInvocationExpressionSyntax:new(2, default, elementTypeExpression);
            end

            local namedTypeSymbol = System.cast(MicrosoftCodeAnalysis.INamedTypeSymbol, symbol);
            if namedTypeSymbol:getTypeKind() == 5 --[[TypeKind.Enum]] then
                return CSharpLuaLuaAst.LuaIdentifierNameSyntax.Int;
            end

            if CSharpLua.Utility.IsDelegateType(namedTypeSymbol) then
                return CSharpLuaLuaAst.LuaIdentifierNameSyntax.Delegate;
            end

            local baseTypeName = GetTypeShortName(this, namedTypeSymbol, transfor, node);
            if namedTypeSymbol:getTypeArguments():getLength() == 0 then
                return baseTypeName;
            else
                local invocationExpression = CSharpLuaLuaAst.LuaInvocationExpressionSyntax:new(1, baseTypeName);
                for _, typeArgument in System.each(namedTypeSymbol:getTypeArguments()) do
                    local typeArgumentExpression = GetTypeName(this, typeArgument, transfor, node);
                    invocationExpression:AddArgument(typeArgumentExpression);
                end
                return invocationExpression;
            end
        end;
        MayHaveCodeMeta = function (this, symbol) 
            return symbol:getDeclaredAccessibility() == 6 --[[Accessibility.Public]] and not CSharpLua.Utility.IsFromCode(symbol);
        end;
        GetTypeShortString = function (this, symbol) 
            local typeSymbol = System.cast(MicrosoftCodeAnalysis.INamedTypeSymbol, symbol:getOriginalDefinition());
            local namespaceName = GetNamespaceMapName(this, typeSymbol:getContainingNamespace());
            local name;
            if typeSymbol:getContainingType() ~= nil then
                name = "";
                local containingType = typeSymbol:getContainingType();
                repeat
                    name = (containingType:getName() or "") .. '.' .. (name or "");
                    containingType = containingType:getContainingType();
                until not (containingType ~= nil);
                name = name .. (typeSymbol:getName() or "");
            else
                name = typeSymbol:getName();
            end
            local fullName;
            if typeSymbol:getTypeArguments():getLength() == 0 then
                if #namespaceName > 0 then
                    fullName = ("{0}.{1}"):Format(namespaceName, name);
                else
                    fullName = name;
                end
            else
                if #namespaceName > 0 then
                    fullName = ("{0}.{1}_{2}"):Format(namespaceName, name, typeSymbol:getTypeArguments():getLength());
                else
                    fullName = ("{0}_{1}"):Format(name, typeSymbol:getTypeArguments():getLength());
                end
            end
            return fullName;
        end;
        GetTypeShortName = function (this, symbol, transfor, node) 
            local name = GetTypeShortString(this, symbol);
            if MayHaveCodeMeta(this, symbol) then
                local info = CSharpLua.Utility.GetOrDefault1(this.typeMetas_, name, nil, System.String, CSharpLuaXmlMetaProvider.TypeMetaInfo);
                if info ~= nil then
                    local newName = info:getModel().Name;
                    if newName ~= nil then
                        name = newName;
                    end
                end
            end
            if transfor ~= nil then
                name = transfor:ImportTypeName(name, symbol, node);
            end
            return CSharpLuaLuaAst.LuaIdentifierNameSyntax:new(1, name);
        end;
        GetTypeMetaInfo = function (this, memberSymbol) 
            local typeName = GetTypeShortString(this, memberSymbol:getContainingType());
            return CSharpLua.Utility.GetOrDefault1(this.typeMetas_, typeName, nil, System.String, CSharpLuaXmlMetaProvider.TypeMetaInfo);
        end;
        IsPropertyField = function (this, symbol) 
            if MayHaveCodeMeta(this, symbol) then
                local default = GetTypeMetaInfo(this, symbol);
                if default ~= nil then
                    default = default:GetPropertyModel(symbol:getName());
                end
                local info = default;
                return info ~= nil and info.IsAutoField;
            end
            return false;
        end;
        GetFieldCodeTemplate = function (this, symbol) 
            if MayHaveCodeMeta(this, symbol) then
                local default = GetTypeMetaInfo(this, symbol);
                if default ~= nil then
                    local extern = extern:GetFieldModel(symbol:getName());
                    if extern ~= nil then
                        extern = extern.Template;
                    end
                    default = extern;
                end
                return default;
            end
            return nil;
        end;
        GetProertyCodeTemplate = function (this, symbol, isGet) 
            if MayHaveCodeMeta(this, symbol) then
                local default = GetTypeMetaInfo(this, symbol);
                if default ~= nil then
                    default = default:GetPropertyModel(symbol:getName());
                end
                local info = default;
                if info ~= nil then
                    local extern;
                    if isGet then
                        local ref = info.get;
                        if ref ~= nil then
                            ref = ref.Template;
                        end
                        extern = ref;
                    else
                        local out = info.set;
                        if out ~= nil then
                            out = out.Template;
                        end
                        extern = out;
                    end
                    return extern;
                end
            end
            return nil;
        end;
        GetInternalMethodMetaInfo = function (this, symbol, metaType) 
            assert(symbol ~= nil);
            if symbol:getDeclaredAccessibility() ~= 6 --[[Accessibility.Public]] then
                return nil;
            end

            local codeTemplate = nil;
            if not CSharpLua.Utility.IsFromCode(symbol) then
                local default = GetTypeMetaInfo(this, symbol);
                if default ~= nil then
                    local extern = extern:GetMethodMetaInfo(symbol:getName());
                    if extern ~= nil then
                        extern = extern:GetMetaInfo(symbol, metaType);
                    end
                    default = extern;
                end
                codeTemplate = default;
            end

            if codeTemplate == nil then
                if symbol:getIsOverride() then
                    if symbol:getOverriddenMethod() ~= nil then
                        codeTemplate = GetInternalMethodMetaInfo(this, symbol:getOverriddenMethod(), metaType);
                    end
                else
                    local interfaceImplementations = CSharpLua.Utility.InterfaceImplementations(symbol, MicrosoftCodeAnalysis.IMethodSymbol);
                    if interfaceImplementations ~= nil then
                        for _, interfaceMethod in System.each(interfaceImplementations) do
                            codeTemplate = GetInternalMethodMetaInfo(this, interfaceMethod, metaType);
                            if codeTemplate ~= nil then
                                break;
                            end
                        end
                    end
                end
            end
            return codeTemplate;
        end;
        GetMethodMetaInfo = function (this, symbol, metaType) 
            symbol = CSharpLua.Utility.CheckOriginalDefinition(symbol);
            return GetInternalMethodMetaInfo(this, symbol, metaType);
        end;
        GetMethodMapName = function (this, symbol) 
            return GetMethodMetaInfo(this, symbol, 0 --[[MethodMetaType.Name]]);
        end;
        GetMethodCodeTemplate = function (this, symbol) 
            return GetMethodMetaInfo(this, symbol, 1 --[[MethodMetaType.CodeTemplate]]);
        end;
        __init__ = function (this) 
            this.namespaceNameMaps_ = System.Dictionary(System.String, System.String)();
            this.typeMetas_ = System.Dictionary(System.String, CSharpLuaXmlMetaProvider.TypeMetaInfo)();
        end;
        __ctor__ = function (this, files) 
            __init__(this);
            for _, file in System.each(files) do
                local xmlSeliz = SystemXmlSerialization.XmlSerializer(System.typeof(CSharpLuaXmlMetaProvider.XmlMetaModel));
                System.try(function () 
                    System.using(SystemIO.FileStream(file, 3 --[[FileMode.Open]], 1 --[[FileAccess.Read]], 1 --[[FileShare.Read]]), function (stream) 
                        local model = System.cast(CSharpLuaXmlMetaProvider.XmlMetaModel, xmlSeliz:Deserialize(stream));
                        if model.Namespaces ~= nil then
                            for _, namespaceModel in System.each(model.Namespaces) do
                                LoadNamespace(this, namespaceModel);
                            end
                        end
                    end);
                end, function (default) 
                    local e = default;
                    System.throw(System.Exception(("load xml file wrong at {0}"):Format(file), e));
                end);
            end
        end;
        return {
            GetTypeName = GetTypeName, 
            GetTypeShortName = GetTypeShortName, 
            IsPropertyField = IsPropertyField, 
            GetFieldCodeTemplate = GetFieldCodeTemplate, 
            GetProertyCodeTemplate = GetProertyCodeTemplate, 
            GetMethodMapName = GetMethodMapName, 
            GetMethodCodeTemplate = GetMethodCodeTemplate, 
            __ctor__ = __ctor__
        };
    end);
end);