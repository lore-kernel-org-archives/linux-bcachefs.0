Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852591D14E9
	for <linux-bcachefs@vger.kernel.org>; Tue, 19 Nov 2024 15:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732028906; cv=none; b=O0yt0vp6iFcZgUraduqzjiGFY0b0anPM11e9J2ax1W1KlVQXaqhTOW0Xb5y2WmhRR8jSuWQ/+hb/uvaXxjZHdL07TQlGCRTDeLnpmjZTLNLTav89SmIUBPy0ikweYFRgV2sEFPrqr0VozyZGYzzOGr//TZ1oUQeJz3DfoAjj/3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732028906; c=relaxed/simple;
	bh=OwGfVI5oV4WaVzi8Zp4Zd3CL/BkJ8xhN1pJHGs1FdwE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OvONUdY0MXo89HWz5zUHf90WcS3pZxlTF4YONsgCeVc6RpGyy4ppT1kPpsiD44R/V8pKQjD+wS/cgzr6gW/dCjEcy3//I8pIAUzhrdquf9bwX+OLggwYnduxuMmqdJYNyVSKbhVAIJp77AmmDaInrpjp605jEbvWxFteSUBR4QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=AlUCODJI; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="AlUCODJI"
DKIM-Signature: a=rsa-sha256; bh=C7hLjZtX0kyT5B/WnnwXaUI415NCVxAPhLsXVuIVZCk=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1732027966; v=1; x=1732459966;
 b=AlUCODJImwf7Q+yX9t7g1CxYig/HOwfIA+39TJrrlZKllljk+Gsx2WdtjsdJVQ+rVU5TOWe7
 4Su7+54QW3WgtITo1w8lB5gGT7Q9s6jAxV3wjQ0J72Kc5rn8By83xbkg3U4xmItahpITTTV1RWl
 0Thlwe8qk/9pkN6huwBjKJmdQE8vjCkjJ7WX2+8H+Pz5LwvKYfr0XuyTQF9w+ijNI7JSF523OJJ
 uY3APR/kaYem6R15A6kidsKJBmBm1dcqIv8AQJsVfUMmFjcVbdxVP0B3t2C17XpL9k3pJNhEJD5
 OYToA6sZhy+EfrAzRBsr/QASoU45eda81HywRzvSIQYoQ==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id 5d9fe31f; Tue, 19 Nov 2024
 22:52:46 +0800
Message-ID: <7ce4ff91-b158-4a82-a5cb-054473a1d77d@archlinuxcn.org>
Date: Tue, 19 Nov 2024 22:52:42 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs-tools: hide FUSE in usage when BCACHEFS_FUSE
 disabled
To: kent.overstreet@gmail.com, kent.overstreet@linux.dev,
 lihongbo22@huawei.com
Cc: mmpgouride@gmail.com, linux-bcachefs@vger.kernel.org
References: <20241109102536.99885-2-integral@archlinuxcn.org>
Content-Language: en-US
From: Integral <integral@archlinuxcn.org>
In-Reply-To: <20241109102536.99885-2-integral@archlinuxcn.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi, Kent

Give you a gentle ping :)


On 11/9/24 6:25 PM, Integral wrote:
> When BCACHEFS_FUSE is disabled or not defined, FUSE section shouldn't be displayed
> in bcachefs usage (--help).
>
> Signed-off-by: Integral <integral@archlinuxcn.org>
> ---
>   c_src/bcachefs.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/c_src/bcachefs.c b/c_src/bcachefs.c
> index 77bf6215..9fe4fa1e 100644
> --- a/c_src/bcachefs.c
> +++ b/c_src/bcachefs.c
> @@ -90,9 +90,11 @@ void bcachefs_usage(void)
>   	     "  list                     List filesystem metadata in textual form\n"
>   	     "  list_journal             List contents of journal\n"
>   	     "\n"
> +#ifdef BCACHEFS_FUSE
>   	     "FUSE:\n"
>   	     "  fusemount                Mount a filesystem via FUSE\n"
>   	     "\n"
> +#endif
>   	     "Miscellaneous:\n"
>            "  completions              Generate shell completions\n"
>   	     "  version                  Display the version of the invoked bcachefs tool\n");
> --
> 2.47.0
>
