Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504603C47B
	for <linux-bcachefs@vger.kernel.org>; Sat, 22 Feb 2025 14:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740233807; cv=none; b=Y1rC0f8PiFoMLB5JzPhcC3yuKwTHUez2Tl6vCpqD09xQywSuyRZlpVaD9OT/5gUGElYLZ/NHWrtoK8mka4aaaaS0mJg629BEIxBmqJ8Fth2yxqT8Eoe0BYMkiufLOy12+ZS1x3p/okDh4KQM9PdqdotjVrWfINz6ZCLJtfegv0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740233807; c=relaxed/simple;
	bh=X2hcgCIYiT9Eky8T0U7ikk9tKwm/vYvFACCFKoD4gS8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Uo9EEr3MPwYmDggM4U6+dSR6BcBhUI014b+Z/6A2zNaF4gXyT0jy6u1f2C+1qYzB0hLIEiTml/8eojlv0hOJvddRbKwFDImrixOBV7rcCQSI2Yw1CEJYVek1nxCI7eRtM9M0L+YItmnrXMPguD8NpvXOcO8fPvfhxrYmwgFnyf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sxr/amXQ; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sxr/amXQ"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740233802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VZ0RrW+JGXYP0RLW8Yqb+U7g46uG1U6TdIOy+lQrKWg=;
	b=sxr/amXQpUNKiQulbC14+IfWFxjRUAGeeQgKcVOSbG2hlTDmqJZnSzF9zZOYODNfABqNug
	KF++rm7CfnHnVfF0HXU5cF6NQvByiytarrzBAGwV/q+imY3L9m/nawE4UHF19j/eg9cSqV
	LS7WWzGjk/x7qNNzgZZZAH6/F8wvvUs=
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51.11.1\))
Subject: Re: [PATCH] bcachefs: Remove duplicate condition in return statement
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <f7zphgeldym3m6rdlygmfrzwlgpdqzptvv2bwrq2jotpt2yadp@y7vck65ft3qy>
Date: Sat, 22 Feb 2025 15:16:29 +0100
Cc: linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <0FD94900-D786-4DB2-A5D4-B6B723A940E7@linux.dev>
References: <20250222133100.369710-2-thorsten.blum@linux.dev>
 <f7zphgeldym3m6rdlygmfrzwlgpdqzptvv2bwrq2jotpt2yadp@y7vck65ft3qy>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Migadu-Flow: FLOW_OUT

On 22. Feb 2025, at 15:05, Kent Overstreet wrote:
> On Sat, Feb 22, 2025 at 02:31:01PM +0100, Thorsten Blum wrote:
>> The last two conditions in the return statement are identical. Remove
>> one of them.
>>=20
>> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
>> ---
>> fs/bcachefs/extents.h | 1 -
>> 1 file changed, 1 deletion(-)
>>=20
>> diff --git a/fs/bcachefs/extents.h b/fs/bcachefs/extents.h
>> index 620b284aa34f..8afcf2c75015 100644
>> --- a/fs/bcachefs/extents.h
>> +++ b/fs/bcachefs/extents.h
>> @@ -703,7 +703,6 @@ static inline bool bch2_extent_ptr_eq(struct =
bch_extent_ptr ptr1,
>> 	return (ptr1.cached	=3D=3D ptr2.cached &&
>> 		ptr1.unwritten	=3D=3D ptr2.unwritten &&
>> 		ptr1.offset	=3D=3D ptr2.offset &&
>> -		ptr1.dev	=3D=3D ptr2.dev &&
>> 		ptr1.dev	=3D=3D ptr2.dev);
>>=20
> Actually should have been checking gen:
>=20
>=20
> =46rom b0e5e78f7e890c48b69e24d19e82597daa2d9cf0 Mon Sep 17 00:00:00 =
2001
> From: Kent Overstreet <kent.overstreet@linux.dev>
> Date: Sat, 22 Feb 2025 09:05:36 -0500
> Subject: [PATCH] bcachefs: fix bch2_extent_ptr_eq()
>=20
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> diff --git a/fs/bcachefs/extents.h b/fs/bcachefs/extents.h
> index 8fae6b23a341..ed160aaa9546 100644
> --- a/fs/bcachefs/extents.h
> +++ b/fs/bcachefs/extents.h
> @@ -704,7 +704,7 @@ static inline bool bch2_extent_ptr_eq(struct =
bch_extent_ptr ptr1,
> 		ptr1.unwritten	=3D=3D ptr2.unwritten &&
> 		ptr1.offset	=3D=3D ptr2.offset &&
> 		ptr1.dev	=3D=3D ptr2.dev &&
> -		ptr1.dev	=3D=3D ptr2.dev);
> +		ptr1.gen	=3D=3D ptr2.gen);
> }
>=20
> void bch2_ptr_swab(struct bkey_s);

Thanks, I was about to ask if it should have been gen instead.

Feel free to add:
Reviewed-by: Thorsten Blum <thorsten.blum@linux.dev>

