select * from [covid deaths]
order by 3, 4

select * from [covid vaccinations]
order by 3, 4



select Location, date, total_cases, new_cases, total_deaths, population
from [covid deaths]
order by 1,2

exec sp_help 'covid deaths';

ALTER TABLE [dbo].[covid deaths]
ALTER COLUMN total_cases decimal;


ALTER TABLE [dbo].[covid deaths]
ALTER COLUMN total_deaths decimal


select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..[covid deaths]
where location like '%India%'
order by 1,2




select Location, population, date, max(total_cases)as , (total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..[covid deaths]
--where location like '%India%'
order by 1,2



select Location, population, date, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..[covid deaths]
--where location like '%India%'
group by Location, population, date
order by PercentPopulationInfected desc



select Location, sum(cast(new_deaths as int)) as TotalDeathCount
from PortfolioProject..[covid deaths]
--where location like '%India%'
where continent is null
and location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'Lower middle income', 'Low income')
group by Location
order by TotalDeathCount desc



select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..[covid deaths]
--where location like '%India%'
where continent is not null
group by continent
order by TotalDeathCount desc


select * from [dbo].[covid deaths] dea
join [dbo].[covid vaccinations] vac
on dea.location = vac.location
and dea.date = vac.date

with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(decimal,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from [dbo].[covid deaths] dea
join [dbo].[covid vaccinations] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *,(RollingPeopleVaccinated/population)*100
from PopvsVac


create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(decimal,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from [dbo].[covid deaths] dea
join [dbo].[covid vaccinations] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *,(RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


ALTER TABLE [dbo].[covid deaths]
ALTER COLUMN new_cases decimal;

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_death, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from [dbo].[covid deaths]
where continent is not null
order by 1,2
