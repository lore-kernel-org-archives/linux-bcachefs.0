Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0DCF9F8
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Oct 2024 11:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729252193; cv=none; b=fyeltkO86CfH1N73FVtPtC4eUiMjXklOe/xA0zDLpDpIvexy9nfBw4ioU83MC/9xmZOWmOwllMFx3VrMMd9HhK338qbdMc5OdVbJYs2J8EN3wJmEoFlJ2jrBTKtgT8Ozl3++RdqXdLlpljBF4avuPkz43ofTBTzIuGJ0penImX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729252193; c=relaxed/simple;
	bh=pXefRyOpmkYQIKl93OCwdKthXxqA79VLRwKvALlr5Y8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=M3I8lisBxd0XgpvDAhF/nqw9lFHiS1UrEr4yjwICYP3b9mnQkU96S6x04PfNm2ib70PX4qlC0dqMRktgqsL8ZjC1BgC7yf7lzEY+4nL/HTuDP49KfAygtmEPEN8Acfoul5lY+h2brEe7m+GJq4o1vCDDr9jer2ExQCw+XVcT5gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4XVNHW2nl6z1T8bw;
	Fri, 18 Oct 2024 19:47:51 +0800 (CST)
Received: from kwepemf200016.china.huawei.com (unknown [7.202.181.9])
	by mail.maildlp.com (Postfix) with ESMTPS id 8B3CD1800F2;
	Fri, 18 Oct 2024 19:49:46 +0800 (CST)
Received: from [10.108.234.194] (10.108.234.194) by
 kwepemf200016.china.huawei.com (7.202.181.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 18 Oct 2024 19:49:46 +0800
Message-ID: <608d5a20-b1d4-4cdc-855e-84958b309bca@huawei.com>
Date: Fri, 18 Oct 2024 19:49:45 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] bcachefs: fix disk reservation accounting in
 bch2_folio_reservation_get()
To: Kent Overstreet <kent.overstreet@linux.dev>,
	<linux-bcachefs@vger.kernel.org>
References: <20241018044006.4067521-1-kent.overstreet@linux.dev>
 <20241018044006.4067521-2-kent.overstreet@linux.dev>
Content-Language: en-US
From: "wangjianjian (C)" <wangjianjian3@huawei.com>
In-Reply-To: <20241018044006.4067521-2-kent.overstreet@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemf200016.china.huawei.com (7.202.181.9)

On 2024/10/18 12:40, Kent Overstreet wrote:
> bch2_disk_reservation_put() zeroes out the reservation - oops.
> 
> This fixes a disk reservation leak when getting a quota reservation
> returned an error.
> 
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> ---
>   fs/bcachefs/fs-io-pagecache.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/fs-io-pagecache.c b/fs/bcachefs/fs-io-pagecache.c
> index af3a24546aa3..cde3a0445ee9 100644
> --- a/fs/bcachefs/fs-io-pagecache.c
> +++ b/fs/bcachefs/fs-io-pagecache.c
> @@ -431,9 +431,9 @@ int bch2_folio_reservation_get(struct bch_fs *c,
>   		ret = bch2_quota_reservation_add(c, inode, &res->quota, quota_sectors, true);
>   		if (unlikely(ret)) {
>   			struct disk_reservation tmp = { .sectors = disk_sectors };
> +			res->disk.sectors -= disk_sectors;
>   
>   			bch2_disk_reservation_put(c, &tmp);
> -			res->disk.sectors -= disk_sectors;
I am new to bcachefs, but seems bch2_disk_reservation_put zeros out 
tmp->sectors, no affect to 'res' ?
>   			return ret;
>   		}
>   	}
-- 
Regards

