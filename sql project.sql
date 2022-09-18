use portfolio;
select  * from coviddeath
order by 4;


#fetch the require data

select iso_code,continent,location,date,population from coviddeath


#compare the total total cases and total death

select iso_code,continent,total_cases_per_million,(total_deaths/total_cases_per_million)*100 as death_percentage from coviddeath



#compare total cases and population

select iso_code,continent,total_cases_per_million,population,(total_cases_per_million/population)*100 as covidcasespercentage from coviddeath


#looking at countries highest infection rate compare to population

select location,continent,max(total_cases_per_million),population,max((total_cases_per_million/population))*100 as covidcasespercentage from coviddeath
group by location
order by covidcasespercentage desc


#showing countries at highest death count

select location,max(total_deaths) as maximum_death_percountry from coviddeath
group by location

# Shoing contintents with the highest death count per population

use portfolio;
select continent,max(total_deaths) as toataldeathcount
from coviddeath
where continent is not null
group by continent
order by toataldeathcount desc


#global numbers

select date,sum(new_cases) as total_new_cases,(sum(new_deaths)/sum(new_cases))*100 as new_death_percentage from coviddeath
where continent is not null
group by date
 
#using vaccination table(join the two table using join keyword)
#Total population vs vaccination and rolling count

select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,sum(cv.new_vaccinations) over(partition by cd.location order by cd.location, cd.date) as rolling_new_vaccinations from coviddeath as cd join covidvaccination as cv on cd.location= cv.location and cd.date=cv.date
where cd.continent is not null

#if we do the comparition of Total population vs vaccination we got error like unknown column'rolling_new_vaccination' so i use cte(common table expression).

with popvsvac(continent,location,date,population,new_vaccinations,rolling_new_vaccinations)
as
(select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,sum(cv.new_vaccinations) over(partition by cd.location order by cd.location, cd.date) as rolling_new_vaccinations from coviddeath as cd join covidvaccination as cv on cd.location= cv.location and cd.date=cv.date
where cd.continent is not null
)
select * ,(rolling_new_vaccinations/population)*100 as vacination_percentage from popvsvac