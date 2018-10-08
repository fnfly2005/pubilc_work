/*票类表*/
select
    TicketClassID,
    PerformanceID,
    Description
from
    S_TicketClass
where
    TicketClassID is not null
