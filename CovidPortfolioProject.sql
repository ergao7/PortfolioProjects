Select *
From PortfolioProject.CovidDeaths
Where continent is not Null and continent != ''
order by 3,4

-- Select *
-- FROM PortfolioProject.CovidVaccinations
-- order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject.CovidDeaths
order by 1,2

-- Total Cases vs Total new_deaths
-- Shows likelihood of dying if contracted with COVID by country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
From PortfolioProject.CovidDeaths
Where location like '%states%'
order by 1,2

-- Shows percentage of population got COVID by country
select location, date, total_cases, population, (total_cases/population)*100 as infection_rate
From PortfolioProject.CovidDeaths
Where location like '%states%'
order by 1,2


-- Looking at Countries with Highest Infection Rate compared to Population
select location, population, max(total_cases) as highest_infection_count,MAX((total_cases/population)*100) as infection_rate
From PortfolioProject.CovidDeaths
group by location, population
order by infection_rate desc

-- Showing Countries with Highest Death Count per Population
select location, max(cast(total_deaths as signed)) as max_death_count
From PortfolioProject.CovidDeaths
Where continent != ''
group by location
order by max_death_count desc



-- CONTINENTAL NUMBERS

-- Showing continents with the highest death count per population
Select continent, max(cast(total_deaths as signed)) as max_death_count
from PortfolioProject.CovidDeaths
where continent !=''
group by continent
order by max_death_count desc






-- GLOBAL NUMBERS


select `date`, sum(new_cases) as total_cases, sum(cast(new_deaths as signed)) as total_deaths, sum(cast(new_deaths as signed))/sum(new_cases)*100 as death_percentage
From PortfolioProject.CovidDeaths
where continent !=''
group by `date`
order by 1,2

 
-- Looking at Total Population vs Vaccination
 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(vac.new_vaccinations, signed)) OVER (partition by dea.location order by dea.location, dea.date) as rolling_vaccinations
, 
from PortfolioProject.CovidDeaths dea
join PortfolioProject.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent !=''
order by 2,3

-- Use CTE
with PopvsVac (Continent, Location, Date, Population, new_vaccination, rolling_vaccinations)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(vac.new_vaccinations, signed)) OVER (partition by dea.location order by dea.location, dea.date) as rolling_vaccinations
from PortfolioProject.CovidDeaths dea
join PortfolioProject.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent !=''
-- order by 2,3
)
Select *, (rolling_vaccinations/population)*100 as percent_vaccinated
from PopvsVac



-- Creating View to store data for later visualizations

Create view Population_Vaccinated AS
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(vac.new_vaccinations, signed)) OVER (partition by dea.location order by dea.location, dea.date) as rolling_vaccinations
from PortfolioProject.CovidDeaths dea
join PortfolioProject.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent !=''
-- order by 2,3

select * 
from population_vaccinated
