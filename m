Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1692EAE5
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jul 2024 13:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721223958; cv=none; b=c4+xWTlVhd83d5brtFmKJxBHeDbBU5mOWo3sdY2u6cVb3zjBqvpsqLvSyWNEFVEIFU6Knt4+BDsQe2IYed0IzCnaY2B5LgIqTQ1CtcRCq76TmTCTW6y0iChKb9flIcGIg7L8wP2r2w9TFQtSmHuS/635dVtWQwXC8igppjJMagw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721223958; c=relaxed/simple;
	bh=nZ51EW8Eg2+XrdYWr0LkStQdCZhPp9xlSQWVAEGGK7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jCZQEGHBKIQrzqZ8lQZLdyCqTIVmMqoY28S1XcEJHbPVDR5lAwCYLvlV5HixvLMRv24PfhprHAKZWiUe0oHw1C+mPJVK10c/Jsr43eByWYLeKZpiVYrc97iQDP7aVLReTbt0pgf/SmUFsm3oB5+1mTDWiFh6sRYEaa5waiURWK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WPHGc4jm3zdhwS;
	Wed, 17 Jul 2024 21:44:08 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 79240180087;
	Wed, 17 Jul 2024 21:45:52 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 17 Jul 2024 21:45:52 +0800
Message-ID: <d77d902c-95d8-404b-9e3a-751e0099ec37@huawei.com>
Date: Wed, 17 Jul 2024 21:45:51 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Suggestions for the bcachefs community
Content-Language: en-US
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>
References: <bfb96546-cf04-421b-b876-2017d20d323f@huawei.com>
 <z6pwyj3w7u5etmzrubglx2ipnavpguxui3wvwjxjci6m5j4ots@upnbrzwtg4yl>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <z6pwyj3w7u5etmzrubglx2ipnavpguxui3wvwjxjci6m5j4ots@upnbrzwtg4yl>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/7/17 21:38, Kent Overstreet wrote:
> On Wed, Jul 17, 2024 at 11:12:14AM GMT, Hongbo Li wrote:
>> Hi, Kent
>>      I've noticed that the main change log for bcachefs has not been included
>> in the release notes for the latest Linux 6.10, which may cause some
>> confusion. I'm not sure if it's because you're too busy to publish some
>> change logs, or if there are other reasons behind it. I thank it's necessary
>> to work together with the bcachefs developers to build up the bcachefs
>> community, keeping it in sync with the community development of other file
>> systems. Of course, this depends on whether you can spare the time to
>> contribute to this, and the efforts of the bcachefs developers can also be
>> leveraged to accomplish this work.
>>
>> Thanks,
>> Hongbo
> 
> Published where?

Here is the news:

https://kernelnewbies.org/Linux_6.10

Thanks,
Hongbo
