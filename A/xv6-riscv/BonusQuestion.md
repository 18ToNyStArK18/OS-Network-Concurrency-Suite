I implemented a different algorithm for the eviction for the bonus part
The core logic behind the new algo is first checks if there are any clean pages 
     then if there are any clean pages it swaps out the page with min seq number 
     and clean and not the code/data
The reason behind this swapping the clean files is basically just discarding 
    the page if its a dirty we need to store it in the swapspace
so the swapping the clean files is optimal than dirty pages
so first i am finding the clean pages if there are no clean pages then its normal fifo atp

