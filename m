Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D12014F123
	for <linux-bcachefs@vger.kernel.org>; Thu, 31 Oct 2024 08:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730361980; cv=none; b=m2gXzyJyEM2GxOC2iVzAZciGgll2j+emPiUNqyYXVIHc8Y5tb0hkvnlqVnhX3uastJFSA0yYUomBDwU1FnLaU+3rt5qa8C7SG2gedLrhVQPzyuwcIot3k/ZglxAaDlONQeltsSvFvPZ2E3Aqn+EdHrLubBVYT2HAiV2wydQimlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730361980; c=relaxed/simple;
	bh=3GKuoXlUb4sBHFWEGDEa7EAC85UjktUUX5dthpginkc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R5T0Bc805SUR6b6j6T1Q39r0HQswBI5e3PlnQDLbC1w3jC5QAAxW1ebdsQ35k1YAcf54PaGaXGdz01qEA8vStuJqBj7nRxABjDh4pjKdTYSvsksIx9Gr98noQmQcyJ1JUGgKoMiTmqaqqFp2mc8Lg0AuDYDYpkydm3+aBj2ggho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tfcs1zbt; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tfcs1zbt"
Message-ID: <da24a338-72ba-4148-be01-359d740a5aba@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730361971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UfcjOajrwVtzKxTiqzYZ6vGRTnzD9EP7krs6nuwewyo=;
	b=tfcs1zbtqVGnx7PsU8mKRhY+mgweXgvO6BdXN+qzUUtYAAFyjgUDTTM1MtvKNFLYFloL2C
	BVgPquef0W7jNQuf+S+gOOBSRDfLFqqTS2e6uxnHKT9Y/h+uSQa6q1t6L89iegkVn3UCem
	g97QwT+eMAHpojAPGnSEFZVMtECc22A=
Date: Thu, 31 Oct 2024 16:05:44 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] bcachefs: Correct the description of the '--bucket=size'
 options
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Youling Tang <tangyouling@kylinos.cn>
References: <20241016015026.1555670-1-youling.tang@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Youling Tang <youling.tang@linux.dev>
In-Reply-To: <20241016015026.1555670-1-youling.tang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi, Kent

Give you a friendly ping. 🙂

BTW, is the following patch needed?
[1] 
https://lore.kernel.org/linux-bcachefs/20240709011134.79954-1-youling.tang@linux.dev/
[2] 
https://lore.kernel.org/linux-bcachefs/20240924025350.3948674-1-youling.tang@linux.dev/
[3] 
https://lore.kernel.org/linux-bcachefs/20240927084042.1516361-1-youling.tang@linux.dev/
[4] 
https://lore.kernel.org/linux-bcachefs/20241016014911.1555607-1-youling.tang@linux.dev/

Thanks,
Youling.

On 2024/10/16 09:50, Youling Tang wrote:
> From: Youling Tang <tangyouling@kylinos.cn>
>
> Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
> ---
>   fs/bcachefs/opts.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
> index cb2e244a2429..92eae5636f2b 100644
> --- a/fs/bcachefs/opts.h
> +++ b/fs/bcachefs/opts.h
> @@ -487,7 +487,7 @@ enum fsck_err_opts {
>   	  OPT_DEVICE,							\
>   	  OPT_UINT(0, S64_MAX),						\
>   	  BCH2_NO_SB_OPT,		0,				\
> -	  "size",	"Size of filesystem on device")			\
> +	  "size",	"Specifies the bucket size; must be greater than the btree node size")\
>   	x(durability,			u8,				\
>   	  OPT_DEVICE|OPT_SB_FIELD_ONE_BIAS,				\
>   	  OPT_UINT(0, BCH_REPLICAS_MAX),				\
