export const NFTCard = ({ nft }) => {

    return (
        <div className="w-1/4 flex flex-col ">
        <div className="rounded-md">
        <a target={"_blank"} href={`https://mumbai.polygonscan.com/address/${nft.contract.address}`}> 
        <img className="object-cover h-128 w-full rounded-t-md" src={nft.media[0].gateway} ></img>
        </a>
        </div>
        <div className="flex flex-col y-gap-2 px-2 py-3 bg-slate-100 rounded-b-md h-110 ">
            <div className="">
                <h2 className="text-xl text-gray-800">{nft.title}</h2>
                <p className="text-gray-600">Id: {nft.id.tokenId.substr(nft.id.tokenId.length - 4)}</p>
                <p className="text-gray-600" >Contract: {`${nft.contract.address.substr(0, 5)}...${nft.contract.address.substr(nft.contract.address.length - 4)}`}</p>
            </div>
            <div className="flex-grow mt-2">
                <p className="text-gray-600">Description: {nft.description?.substr(0, 150)}</p>
            </div>
            <div>
                <a target={"_blank"} href={`https://mumbai.polygonscan.com/address/${nft.contract.address}`}> View on PolygonSacn</a>
            </div>
        </div>

    </div>
    )
}