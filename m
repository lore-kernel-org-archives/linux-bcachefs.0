Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F0A15E88
	for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 06:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727071674; cv=none; b=sDAveptBD00/qDasJMedu3+VhhxZ+i3eGojj+bPWcuM+KbnbvfKzh4Rw+I2XCQwCdws3ioU/8cieAK4/Xj4HInpdTCvBr3NrFlZe1WA/QzwPx+OM0WtrLDUKNqzBUKxe2IWuXnooE8admL2Zk9ORCAhkSXewodn/ZMmqu9t/RYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727071674; c=relaxed/simple;
	bh=nRmudIAH54McuFxnNX/s2tUDLtwWUq3zaPyzaMMCo0g=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=m5XbF3i3jqPOtGODxrKM3gRgtRTdIHO8m+lBNxyuKOuCZ6Pq9TUSqhfiA2bVU+C5SRJ3g1JVdtwwHOukPCxYxGUdwJKDXI0IR37Bz0JJpTxukezM6YelmiktRcILVUJkOjUNJvylK55QAaxny2B/ceFfw6UyQOAfrXg692YxAZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4XBswJ38LLzQrWW;
	Mon, 23 Sep 2024 14:07:28 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 8CB73180113;
	Mon, 23 Sep 2024 14:07:47 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 23 Sep 2024 14:07:47 +0800
Message-ID: <e05fef02-dfa9-4ead-873b-e5083b27cbab@huawei.com>
Date: Mon, 23 Sep 2024 14:07:46 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH resend v2] bcachefs: reject unknown mount options
To: David Disseldorp <ddiss@suse.de>, Kent Overstreet
	<kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, Martin Doucha <martin.doucha@suse.com>
References: <20240917013957.13353-1-ddiss@suse.de>
 <fiwda3johielxusg2ab73km7xo6f3skobw7c7rv3mc4g6epgtf@vo5urbm7nb6a>
 <20240923035903.32589261.ddiss@suse.de>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20240923035903.32589261.ddiss@suse.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/9/23 11:59, David Disseldorp wrote:
> On Sat, 21 Sep 2024 19:13:31 -0400, Kent Overstreet wrote:
> 
>> I applied this and got some new failures in the CI - it seems something
>> is broken in remount.
> ...
>> 00163 bcachefs: bch2_parse_one_mount_opt() Bad mount option rwerrors
>> 00163 Error: Invalid argument
>> 00163 Error 1 at /host//home/testdashboard/ktest/tests/fs/bcachefs/ec.ktest 32 from: mount -o remount,ro /mnt, exiting
>> 00163 Error 1 at /host/home/testdashboard/ktest/tests/prelude.sh 269 from: ( set -e; run_test $i ), exiting
>> 00163
>> 00163 ========= FAILED ec_small in 2s
>>
>> The test is just doing
>> mount -o remount,ro /mnt
>>
>> Thomas, this is likely something you introduced, think you could take a
>> look?
> 
> Thanks for the details. "mount -o remount,ro <mnt>" works fine for me,
> and I'm not aware of anything that could be providing the "rwerrors"
It seems rw, errors=xxx which misses a comma.
> parameter. Which version of mount / util-linux is used here?
