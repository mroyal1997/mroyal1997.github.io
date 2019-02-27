 /* Create template tables to test each solution for correctness:
 CREATE TABLE Players(PlayerID, FirstName, LastName, PositionID);
 INSERT INTO players VALUES(1, "A", "A", 1);
 INSERT INTO players VALUES(2, "B", "B", 1);
 INSERT INTO players VALUES(3, "C", "C", 0);
 INSERT INTO players VALUES(4, "D", "D", 0);
 INSERT INTO players VALUES(5, "E", "E", 1);
 INSERT INTO players VALUES(6, "F", "F", 1);

 CREATE TABLE Salaries(SalaryID, PlayerID, Amount);
 INSERT INTO salaries VALUES(1, 1, 10000);
 INSERT INTO salaries VALUES(2, 2, 20000);
 INSERT INTO salaries VALUES(3, 3, 30000);
 INSERT INTO salaries VALUES(4, 4, 40000);
 INSERT INTO salaries VALUES(5, 5, 50000);
 INSERT INTO salaries VALUES(6, 6, 60000);

 CREATE TABLE ScoredGoals(GoalId, PlayerID, GameID, Minute);
 INSERT INTO ScoredGoals VALUES(1, 5, 000, 20);
 INSERT INTO ScoredGoals VALUES(2, 5, 000, 40);
 INSERT INTO ScoredGoals VALUES(3, 6, 001, 10);
 INSERT INTO ScoredGoals VALUES(4, 4, 001, 40);
 INSERT INTO ScoredGoals VALUES(5, 6, 001, 50);
 INSERT INTO ScoredGoals VALUES(5, 6, 001, 30);
 INSERT INTO ScoredGoals VALUES(6, 6, 002, 40);

 CREATE TABLE Positions(PositionID, PositionName);
 INSERT INTO Positions VALUES(1, "center");
 INSERT INTO Positions VALUES(0, "goalie");
 */

/* 1. 3rd highest paid player */
select FirstName, LastName, Amount from Players as p, Salaries as s where s.PlayerID = p.PlayerID order by Amount desc limit 1 offset 2;


/* 2. 3rd lowest paid player */
select FirstName, LastName, Amount from Players as p, Salaries as s where s.PlayerID = p.PlayerID order by Amount asc limit 1 offset 2;


/* 3. Which position scored the most goals? */
 select PositionName, count(po.PositionID) from Players as pl, ScoredGoals as sg, Positions as po where pl.PlayerID = sg.PlayerID and po.PositionID = pl.PositionID group by po.PositionID order by count(po.PositionID) desc limit 1;


/* 4. Which players never scored? */
create table tempGoalCount(PlayerID, FirstName, LastName, playerGoalCount);
insert into tempGoalCount select pl.PlayerID, pl.FirstName, pl.LastName, count(FirstName) from Players as pl, ScoredGoals as sg where pl.PlayerID = sg.PlayerID group by pl.PlayerID;
insert into tempGoalCount select PlayerID, FirstName, LastName, 0 from Players;

select PlayerID, FirstName, LastName, playerGoalCount from tempGoalCount group by PlayerID having sum(playerGoalCount) = 0;


/* 5. Which player scored the most goals? */
create table PlayerGoalCount(PlayerID, FirstName, LastName, playerGoalCount);
insert into PlayerGoalCount select pl.PlayerID, pl.FirstName, pl.LastName, count(FirstName) from Players as pl, ScoredGoals as sg where pl.PlayerID = sg.PlayerID group by pl.PlayerID;
insert into PlayerGoalCount select PlayerID, FirstName, LastName, 0 from Players;

select PlayerID, FirstName, LastName, sum(playerGoalCount) from PlayerGoalCount group by PlayerID order by sum(playerGoalCount) desc limit 1;


/* 6. Which player scored the most goals in a single game? */
create table goalsPerPlayerPerGame(GameID, PlayerID, FirstName, LastName, GoalCount);
insert into goalsPerPlayerPerGame select sg.GameID, pl.PlayerID, pl.FirstName, pl.LastName, count(pl.PlayerID) from Players as pl, ScoredGoals as sg where sg.PlayerID = pl.PlayerID group by pl.PlayerID, sg.GameID;

select GameID, PlayerID, FirstName, LastName, max(GoalCount) from goalsPerPlayerPerGame group by GameID;


/* 7. What is the salary paid per goal per position? */
create table TotalSalaryPerPosition(PositionID, PositionName, TotalSalary);
insert into TotalSalaryPerPosition select po.PositionID, po.PositionName, sum(s.Amount) from Salaries as s, Players as pl, Positions as po where s.PlayerID = pl.PlayerID and po.PositionID = pl.PositionID group by po.PositionID;

create table TotalGoalsPerPosition(PositionID, PositionName, TotalGoals);
insert into TotalGoalsPerPosition select po.PositionID, po.PositionName, count(*) from Players as pl, ScoredGoals as sg, Positions as po where pl.PlayerID = sg.PlayerID and pl.PositionID = po.PositionID group by po.PositionID;

select g.PositionID, g.PositionName, s.TotalSalary / g.TotalGoals from TotalGoalsPerPosition as g, TotalSalaryPerPosition as s where g.PositionID = s.PositionID;


/* 8. What is the average minute of scored goals for each game? */
select sg.GameID, avg(sg.Minute) from ScoredGoals as sg group by sg.GameID;


/* 9. What should the Salaries table look like if we needed to track historical data?
  Depending on how the salaries are incremented year-to-year, the salaries table should be modified differently.

  If the salary changed by an arbitrary amount year-to-year, or at different intervals than year-to-year, the
  Salaries table should include a timestamp whenever salary is changed, with a separate row for each individual
  player every time their salary changes.

  If the salary increases by a constant amount year-to-year, however, a more efficient approach is possible. One
  could add hireDate and annualPercentIncrease to the table. This would allow us to calculate the salary for a
  given year after the start date without having to fill the table up with a row for every time the salary is increased.
  We would still have one row per player, but we would add a hireDate column and an annualPercentIncrease column to
  maximize space efficiency.
*/



