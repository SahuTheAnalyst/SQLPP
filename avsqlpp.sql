use Accident
select *
from dbo.vehicle
select *
from dbo.accident

-- How many accidents occur in Rural and Urban areas?

select area, count(AccidentIndex) Total_Acc
from dbo.accident
group by Area

-- Which day of the week has most accidents?

select Day, count(day) as DDay
from dbo.accident
group by Day
order by DDay desc

-- What is the average age of the vehicle involved in the accident?

select VehicleType, count(AccidentIndex) as TotAcc, avg(AgeVehicle) as AvgYear
from vehicle
where AgeVehicle is not NULL
group by VehicleType
order by TotAcc desc

-- Can we identify any pattern/trend in accident based on age of Vehicles?

select AgeGroup, COUNT(AccidentIndex) as TA, AVG(AgeVehicle) as AY
from (select AccidentIndex, AgeVehicle,
		case 
		when AgeVehicle between 0 and 5 then 'New'
		when AgeVehicle between 6 and 10 then 'Normal'
		else 'Old'
		end as 'AgeGroup'
	from dbo.vehicle)
as SubQuery
Group by AgeGroup

-- Are there any specific weather conditions conditions contributing to severe accidents?

declare @Severity varchar(100)
set @Severity = 'Fatal'

select WeatherConditions, count(Severity) as TA
from dbo.accident
where Severity = @Severity
group by WeatherConditions
order by 2 desc

-- Do accidents ofter involve impact on left hand side?

select LeftHand, COUNT(AccidentIndex) as TA
from dbo.vehicle	
group by LeftHand
having LeftHand is not null

-- Are there any relationship between Journey Purpose and severity of accident?

select v.JourneyPurpose, count(a.Severity) as TA,
			case 
			when COUNT(a.Severity) between 0 and 1000 then 'Low'
			when COUNT(a.Severity) between 1000 and 3000 then 'Moderate'
			else 'Extreme'
			end as 'Level'
from accident a
join vehicle v
on a.AccidentIndex = v.AccidentIndex
group by v.JourneyPurpose
order by TA desc

-- Calculate avg age of vehicle invoved in an accident considering Day ligh and point of impact.

declare @impact varchar(100)
declare @light varchar(100)
set @impact = 'Offside'
set @light = 'Daylight'

select a.LightConditions, v.PointImpact, AVG(v.AgeVehicle) as AA
from dbo.accident a
join dbo.vehicle v
on a.AccidentIndex = v.AccidentIndex
group by a.LightConditions, v.PointImpact
having PointImpact = @impact and LightConditions = @light