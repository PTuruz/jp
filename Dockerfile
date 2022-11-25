#add base 
FROM mcr.microsoft.com/dotnet/runtime:5.0 AS base
WORKDIR /app

#add build image
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src

#install git
RUN apt-get update && apt-get install -y \
    git 

#get sources from git
RUN git clone https://github.com/serilog/serilog-sinks-file

#change workdir
WORKDIR /src/serilog-sinks-file

#build
RUN dotnet restore
RUN dotnet build -f net5.0 -c Release src/Serilog.Sinks.File/Serilog.Sinks.File.csproj  -o /app/build

#publish
FROM build AS publish
RUN dotnet publish -f net5.0 -c Release src/Serilog.Sinks.File/Serilog.Sinks.File.csproj  -o /app/publish

#create final image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

#run app
ENTRYPOINT ["dotnet", "Serilog.Sinks.File.dll"]
