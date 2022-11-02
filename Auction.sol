contract SimpleAuction {
    address[] saveBuyerAddress;
    address[] saveSellerAddress;

    uint buyerclock = 110;
    uint sellerclock;
    uint socialwelfare = 0;
    mapping(address => uint) public buyer;
    mapping(address => uint) public seller;

    function registBuyer(uint bidprice) public returns(address[] memory){//注册买家
        buyer[msg.sender] = bidprice;
        saveBuyerAddress.push(msg.sender);
        return saveBuyerAddress;
    }

    function registSeller(uint bidprice) public returns(address[] memory){//注册卖家
        seller[msg.sender] = bidprice;
        saveSellerAddress.push(msg.sender);
        return saveSellerAddress;
    }

    function get_buyerMaxPrice() public returns(uint){//获取最高出价的买家位置
		uint maxindex = 0;
        uint index = 0;
        while(index < saveBuyerAddress.length){
            if(buyer[saveBuyerAddress[index]]>buyer[saveBuyerAddress[maxindex]]){
                maxindex = index;
            }
            index += 1;
        }
        return maxindex;
	}

    function get_sellerMinPrice() public returns(uint){//获取最低售价的卖家位置
		uint minindex = 0;
        uint index = 0;
        while(index < saveSellerAddress.length){
            if(seller[saveSellerAddress[index]]<seller[saveSellerAddress[minindex]]){
                minindex = index;
            }
            index += 1;
        }
        return minindex;
	}

    function get_averageBuyerPrice() public returns(uint){//获取买家售价的平均值
        uint PriceSum = 0;
        uint index = 0;
        while(index < saveBuyerAddress.length){
            PriceSum += buyer[saveBuyerAddress[index]];
            index += 1;
        }
        sellerclock = PriceSum/(saveBuyerAddress.length);
        return sellerclock;
    }

    function auction() public returns(uint,uint){
        uint maxbuyerindex = get_buyerMaxPrice();
        uint minsellerindex = get_sellerMinPrice();

        uint buyerprice = buyer[saveBuyerAddress[maxbuyerindex]];
        uint sellerprice = seller[saveSellerAddress[minsellerindex]];

        uint nowsellerprice = sellerprice;
        uint nowbuyerprice = buyerprice;

        //通过时钟决定买家出价
        while(buyerprice<buyerclock){
            buyerclock-=5;
        }
        buyerprice = buyerclock;

        //通过时钟决定卖家出价
        while(sellerprice>sellerclock){
            sellerclock+=5;
        }
        sellerprice = sellerclock;

        require(sellerclock <= buyerclock, "auction close");

        socialwelfare += sellerprice + buyerprice;
        array_pop(maxbuyerindex,minsellerindex);
        return (buyerprice,sellerprice);
    }

	function array_pop(uint buyerindex,uint sellerindex) public{//删除成功竞拍买家卖家
        saveBuyerAddress[buyerindex]=saveBuyerAddress[saveBuyerAddress.length-1];
        saveBuyerAddress.pop();
		
        saveSellerAddress[sellerindex]=saveSellerAddress[saveSellerAddress.length-1];
        saveSellerAddress.pop();
	}

    function findMaxBuyerPrice() public returns(uint){
        uint maxindex;
		maxindex = get_buyerMaxPrice();
        return buyer[saveBuyerAddress[maxindex]];
	}

    function findMinSellerPrice() public returns(uint){
        uint minindex;
		minindex = get_sellerMinPrice();
        return seller[saveSellerAddress[minindex]];
	}

    function getSocialWelfare() public returns(uint){
        return socialwelfare;
	}
}