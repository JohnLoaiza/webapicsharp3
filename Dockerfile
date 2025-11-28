# Etapa 1: Build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copiar todo el proyecto
COPY . .

# Restaurar dependencias
RUN dotnet restore "./webapicsharp.csproj"

# Publicar en modo Release
RUN dotnet publish "./webapicsharp.csproj" -c Release -o /app/publish

# Etapa 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# Copiar los binarios publicados
COPY --from=build /app/publish .

# Render usa el puerto 8080 por defecto
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

# Ejecutar la API
ENTRYPOINT ["dotnet", "webapicsharp.dll"]
