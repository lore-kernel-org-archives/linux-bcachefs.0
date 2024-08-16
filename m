Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3E31AC88A;
	Fri, 16 Aug 2024 03:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723779342; cv=none; b=qU0r9EhpVTUKgA6RuAf7JDGmQoPCsqfeGuuBNtG6U1rNMNUkyB9ZJOsp2BlYpLDaYyI5/jSjVPDUAcBx+XM8Yrk0B2FrnOwjodkExj9GUUe0ez+ai5CAaJ1jdRdqf8bhQAmP+KiOvGJ6OilY+5t1YA65pTBJwitJTP/rGJWme3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723779342; c=relaxed/simple;
	bh=MEM4vfjf4cg16A6d5wJ6RKjnIXItvPddOYfhtmgM2h8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jij9GOCTNzbuwC3qbEIdDhgvyn0LrjWLYPtGULbos26gzEzeox2GI75VjwX8OLCW77GleTtN7a+aaYzzf+7ilgB1w239J+qTvB3nRuvon7/qo39ZUU3BONTprP2f6+y0sB/qbPWzDyrgQYRDecgra2PpTPQAPaMMlrhJRnLNJyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WlSDy2n4fz1j6Rs;
	Fri, 16 Aug 2024 11:30:42 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (unknown [7.221.188.25])
	by mail.maildlp.com (Postfix) with ESMTPS id 62C5E1A016C;
	Fri, 16 Aug 2024 11:35:36 +0800 (CST)
Received: from [10.67.111.176] (10.67.111.176) by
 kwepemd500012.china.huawei.com (7.221.188.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 16 Aug 2024 11:35:35 +0800
Message-ID: <340d85f3-ece3-45b8-b482-bfeac04e6ab4@huawei.com>
Date: Fri, 16 Aug 2024 11:35:35 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] bcachefs: support iopoll method
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20240815142034.1561661-1-lizetao1@huawei.com>
 <rqt2hvqaukziy5pzg3v7conihbjwa2icej23qbay3zm5b5kn5s@cvccny7kpz7p>
From: Li Zetao <lizetao1@huawei.com>
In-Reply-To: <rqt2hvqaukziy5pzg3v7conihbjwa2icej23qbay3zm5b5kn5s@cvccny7kpz7p>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggpeml500024.china.huawei.com (7.185.36.10) To
 kwepemd500012.china.huawei.com (7.221.188.25)

Hi,

在 2024/8/15 22:16, Kent Overstreet 写道:
> On Thu, Aug 15, 2024 at 10:20:34PM GMT, Li Zetao wrote:
>> When bcachefs uses io_uring, implement the iopoll method to support
>> IORING_SETUP_IOPOLL.
>>
>> Signed-off-by: Li Zetao <lizetao1@huawei.com>
> 
> tested?
I have tested with fio:

[root]# vi bcachefs.fio
[global]
direct=1
thread=1
norandommap=1
group_reporting=1
time_based=1
ioengine=io_uring

rw=randwrite
bs=4096
runtime=20
numjobs=1
fixedbufs=1
hipri=1
registerfiles=1
sqthread_poll=1

[filename0]
size=1G
iodepth=1
cpus_allowed=20
filename=/mnt/bcachefs/test

The option "hipri=1" need to support IORING_SETUP_IOPOLL for io_uring 
engine.
