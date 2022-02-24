/*
Analisando os dados de Covid 19
Analyzing Covid 19 data

Comandos utilizados: Joins, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
Skills: Joins, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/



SELECT *
FROM PortfolioProject..CovidDeaths;

SELECT *
FROM PortfolioProject..CovidVaccinations
ORDER BY 3,4;

SELECT
	location, 
	date, 
	total_cases, 
	new_cases, 
	total_deaths, 
	population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2;

--Total de casos Vs Total de mortes pelo país selecionado
--Looking at Total Cases vs Total Deaths by selected country
SELECT
	location, 
	date, 
	total_cases,  
	total_deaths,
	(total_deaths/total_cases)*100 AS 'Total de Casos por Total de Mortes'
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%brazil%'
ORDER BY 1,2;

--Total de casos Vs População do país selecionado
--Looking at Total Cases vs Population by selected country
SELECT
	location, 
	date, 
	total_cases,  
	population,
	(total_cases/population)*100 AS 'Percental de casos na população'
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%brazil%'
ORDER BY 1,2;

--Países com maior índice de infecção pela população
--Looking at Coutries with highest infection rate compared to Population
SELECT
	location,
	population,
	MAX(total_cases) as 'Maior índice de infecção',  
	MAX((total_cases/population))*100 AS 'Percental de casos na população'
FROM PortfolioProject..CovidDeaths
GROUP BY location, population
ORDER BY 'Percental de casos na população' DESC;

--Total de Morte Por País
--Showing Countries with the highest Death Count per Population
SELECT
	location,
	MAX(CAST(total_deaths AS INT)) AS 'Total de Mortes por País'
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 'Total de Mortes por País' DESC;

--Total de Mortes por Continente
--Showing Continents with the highest Death Count per Population
SELECT
	continent,
	MAX(CAST(total_deaths AS INT)) AS 'Total de Mortes por Continente'
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 'Total de Mortes por Continente' DESC;

--Dados Gerais
--Global Numbers
SELECT
	SUM(new_cases), 
	SUM(CAST(new_deaths AS INT)), 
	SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 as 'Percentual de mortes'
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL;

--Total de Vacinados pela População
--Looking at Total Population vs Vaccinations
SELECT 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population,
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS INT)) OVER(PARTITION BY dea.location ORDER BY dea.Date) AS 'Total de Vacinados'
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;

--Criando vistas para utilizar posteriormente
--Creating View to store data for later visualizations
CREATE View Total_Morte_Por_Continente AS
SELECT
	continent,
	MAX(CAST(total_deaths AS INT)) AS Total_Morte_Por_Continente
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent;

CREATE VIEW Total_de_Casos_Por_Total_de_Mortes AS
SELECT
	location, 
	date, 
	total_cases,  
	total_deaths,
	(total_deaths/total_cases)*100 AS Total_de_Casos_Por_Total_de_Mortes
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%brazil%';

SELECT *
FROM Total_de_Casos_Por_Total_de_Mortes;
