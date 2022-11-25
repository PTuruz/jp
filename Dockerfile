FROM mcr.microsoft.com/dotnet/runtime:5.0 AS base
WORKDIR /app


FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src

RUN apt-get update && apt-get install -y \
    git 

RUN git clone https://github.com/serilog/serilog-sinks-file

#ADD serilog-sinks-file/ .

COPY serilog-sinks-file/ .
RUN dotnet restore
RUN dotnet build -f net5.0 -c Release serilog-sinks-file/src/Serilog.Sinks.File/Serilog.Sinks.File.csproj  -o /app/build

FROM build AS publish
RUN dotnet publish -f net5.0 -c Release src/Serilog.Sinks.File/Serilog.Sinks.File.csproj  -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Serilog.Sinks.File.dll"]
