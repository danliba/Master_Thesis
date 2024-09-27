%velocity in m/s
function Sv=upward_velocity_2_Sv_UR(vel)

Area = 11*111*1000*150;
Sv = (vel)*Area./ 10^6;
