# SellerCentral

### Process an Amazon.com Seller Central payment raw file to summarize by items sold and fees charged

This is just raw ruby code for now, but will process a file manually if you wish it to.

To get the file:

1.  Log in to your seller central account
2.  Go to the [all statements](https://sellercentral.amazon.com/gp/payments-account/past-settlements.html) page.  (*This link will not work unless logged in to a seller central account*)
3.  Select the Date Range report you want and click **Download Flat File V2**
4.  Open downloaded text file and save it as a CSV file.

*The source file from Amazon starts as a `.txt` file that is tab separated.  I did attempt to work with that file, but was unable to make it work properly.*

The methods are currently set up to be called manually on a file.  Future adjustements could automate it all.  File saving ouf output report is basic for now and saves it in whatever folder you're working in.

