# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /source

# Copy csproj and restore as distinct layers
COPY *.sln .
COPY Frontflip/AdminClient/*.csproj ./Frontflip/AdminClient/
COPY Frontflip/AdminShared/*.csproj ./Frontflip/AdminShared/
COPY Frontflip/Client/*.csproj ./Frontflip/Client/
COPY Frontflip/Server/*.csproj ./Frontflip/Server/
COPY Frontflip/Shared/*.csproj ./Frontflip/Shared/
RUN dotnet restore

# Copy everything else and build
COPY Frontflip/. ./Frontflip/
WORKDIR /source/Frontflip/Server
RUN dotnet publish -c release -o /app --no-restore

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "Frontflip.Server.dll"]
