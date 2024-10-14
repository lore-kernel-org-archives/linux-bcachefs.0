Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82055E57D
	for <linux-bcachefs@vger.kernel.org>; Mon, 14 Oct 2024 01:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728869204; cv=none; b=IJRS+Mcy7oOnxkF5P5PRC+5x9DAQmhV8nxX2dg1SVPMBL9yV/zuDaM6UMXu8pVyxbHF5evEA/i4u2k/Bio8Ey6GqubV5jE2ZPoaDjnyalU4u93+XbM/23CTmgOPACmMEjtECux2mXr/ijNVRaJ8zBaVJZXlTyrqS0dPqv00s4bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728869204; c=relaxed/simple;
	bh=wGbE5+zdi5Fv7zEAsXsLy+Qkc3iJQ4qPOdngLBOuAtM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gAKB8kR2ux148vuSrImoS8WvyHEDKbuzo4xCTWDkxtmi/6MdIqO55QdSu+MwyqyohKU5zGrPVBVaBxAMgi0VOk3p5WKs5snZU7S5AZk/fiUyWZlzomwCtbSMZY+BKMveXpMfaA/mqD5fXnFlLTen6r42QB8dsr8T/e1h+fteDFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=b6hNeeUa; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="b6hNeeUa"
Message-ID: <6d8fa4ef-e230-4313-bdca-e51a43db0e27@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728869200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6NvdnnwZo/raDSaO9HQyfJYGI8ca1niI5ok8I9tGboY=;
	b=b6hNeeUacH5mlpDU/zS7UyNYzmh+PBTYSD4eU7KtdDezQBRhszZRukJu06F6tVLLJGM2Sb
	zTWycvGzLUcmaEg/mtkjZ0ZL75FJA5jTPfPQVNItwkYgJn/Bq7EMcY2f9wvCqGY1RAPkWf
	cF3+l2vL6ppKYvdeYMiLkqjXuRs/2Tk=
Date: Mon, 14 Oct 2024 09:26:12 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] bcachefs: Simplify code in bch2_dev_alloc()
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Youling Tang <tangyouling@kylinos.cn>
References: <20241012075902.1320946-1-youling.tang@linux.dev>
 <4iwneao62n6xuniitihvhp7ojvt2pkjtisnrnax7hyzztyktxm@yn4unwrqqjpb>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Youling Tang <youling.tang@linux.dev>
In-Reply-To: <4iwneao62n6xuniitihvhp7ojvt2pkjtisnrnax7hyzztyktxm@yn4unwrqqjpb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi, Kent

On 2024/10/13 01:30, Kent Overstreet wrote:

> On Sat, Oct 12, 2024 at 03:59:02PM GMT, Youling Tang wrote:
>> From: Youling Tang <tangyouling@kylinos.cn>
>>
>> - Remove unnecessary variable 'ret'.
>> - Remove unnecessary bch2_dev_free() operations.
>>
>> Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
> the 'goto err' style is more readable when you're staring at tons of
> code
Well.

But 'ret' is not needed here.
Does not execute bch2_dev_free() if the ca in the err path is NULL,
so it can be removed.
Can be modified as follows if necessary:
-- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1352,7 +1352,6 @@ static int bch2_dev_alloc(struct bch_fs *c, 
unsigned dev_idx)
  {
         struct bch_member member = bch2_sb_member_get(c->disk_sb.sb, 
dev_idx);
         struct bch_dev *ca = NULL;
-       int ret = 0;

         if (bch2_fs_init_fault("dev_alloc"))
                 goto err;
@@ -1364,10 +1363,9 @@ static int bch2_dev_alloc(struct bch_fs *c, 
unsigned dev_idx)
         ca->fs = c;

         bch2_dev_attach(c, ca, dev_idx);
-       return ret;
+       return 0;
  err:
-       if (ca)
-               bch2_dev_free(ca);
         return -BCH_ERR_ENOMEM_dev_alloc;

  }

Thanks,
Youling.
