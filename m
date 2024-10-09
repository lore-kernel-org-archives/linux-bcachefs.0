Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB831190471;
	Wed,  9 Oct 2024 09:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728465380; cv=none; b=mdLKpDpfh3UwBFbjZ6gw4cB9v9MQ2SRyqP1xL5vIkYTJcqWVxh2Ddl3sYUDOcU7lybGT5pJR88F4E27kerMZ3pzClxeCa7eS3ZJVDVZ32t60gfMFv1yikVPbJXZ1cAUsCZbn03GwSYHIpUlB+5wYVBqmY4h3uvBMII4J7LEnwBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728465380; c=relaxed/simple;
	bh=+n5Z6EHyiC3uE+t8M1UjabpGkO6WhcYJ/7IghC6FbS8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MulEFJSuGLsb+9E/XoIjiw1rYXeBLe6KE1KXY+HEI216L8AwHIhXRf814203TleTrEKYESrBRM7Xpek48DI2JBmcAfGvjCLDdJBWRDrcdiO2lYfooKBjNR9EK9cMZyUESIgMydjS8lx2SOXWIpfioxo5P5+yd9WU5KdEJctQCYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 1dda4392861f11efa216b1d71e6e1362-20241009
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:c55efbc2-ea5b-4e40-ba21-321ddd32f6b6,IP:20,
	URL:0,TC:0,Content:1,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:16
X-CID-INFO: VERSION:1.1.38,REQID:c55efbc2-ea5b-4e40-ba21-321ddd32f6b6,IP:20,UR
	L:0,TC:0,Content:1,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:16
X-CID-META: VersionHash:82c5f88,CLOUDID:e37bfc660498a0c9d1452aabeb14d594,BulkI
	D:241009171018CVWUJEZ6,BulkQuantity:2,Recheck:0,SF:38|23|17|19|43|74|64|66
	|102,TC:nil,Content:4|-5,EDM:-3,IP:-2,URL:1,File:nil,RT:nil,Bulk:40,QS:nil
	,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-UUID: 1dda4392861f11efa216b1d71e6e1362-20241009
X-User: zhaomengmeng@kylinos.cn
Received: from [192.168.109.86] [(1.198.30.91)] by mailgw.kylinos.cn
	(envelope-from <zhaomengmeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1537307015; Wed, 09 Oct 2024 17:16:07 +0800
Message-ID: <633662aa-120c-40e0-a836-da5faa7ed312@kylinos.cn>
Date: Wed, 9 Oct 2024 17:16:03 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] bcachefs: Fix shift-out-of-bounds in
 bch2_stripe_to_text
To: Hongbo Li <lihongbo22@huawei.com>, Zhao Mengmeng <zhaomzhao@126.com>,
 kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241009054325.438556-1-zhaomzhao@126.com>
 <b1c2154d-189a-43fa-84ff-a0d96787ff60@huawei.com>
From: Zhao Mengmeng <zhaomengmeng@kylinos.cn>
In-Reply-To: <b1c2154d-189a-43fa-84ff-a0d96787ff60@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2024/10/9 17:10, Hongbo Li wrote:
> 
> 
> On 2024/10/9 13:43, Zhao Mengmeng wrote:
>> From: Zhao Mengmeng <zhaomengmeng@kylinos.cn>
>>
>> syzbot report a shift-out-of-bounds issue:
>> ------------[ cut here ]------------
>> UBSAN: shift-out-of-bounds in fs/bcachefs/ec.c:147:2
>> shift exponent 108 is too large for 32-bit type 'unsigned int'
>> ----
>> Here s.csum_granularity_bits = 108, so shift is impossible for unsigned
>> int. To fix, add a check in bch2_stripe_validate() to bail out, it has
>> same checking logic with ec_stripe_key_init().
>>
>> Reported-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
>> Tested-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=f8c98a50c323635be65d
>> Suggested-by: Hongbo Li <lihongbo22@huawei.com>
>> Signed-off-by: Zhao Mengmeng <zhaomengmeng@kylinos.cn>
>> ---
>>   fs/bcachefs/ec.c      | 6 ++++++
>>   fs/bcachefs/errcode.h | 3 ++-
>>   2 files changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
>> index 141a4c63142f..bc5ff1331c6f 100644
>> --- a/fs/bcachefs/ec.c
>> +++ b/fs/bcachefs/ec.c
>> @@ -113,6 +113,12 @@ int bch2_stripe_validate(struct bch_fs *c, struct bkey_s_c k,
>>       const struct bch_stripe *s = bkey_s_c_to_stripe(k).v;
>>       int ret = 0;
>>   +    if (s->csum_granularity_bits >= ilog2(le16_to_cpu(s->sectors))) {
> 
> csum_granularity_bits should do the left shift.

If use `1 << s->csum_granularity_bits(108)` to do the check, syzbot will still trigger shift-out-of
bounds warning. So better check the bits directly.

