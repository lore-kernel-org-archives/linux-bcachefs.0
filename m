Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E65148838;
	Thu, 24 Oct 2024 10:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729766919; cv=none; b=u9DETTxUJg7c5jy7hGKL/zT85/nZy3Y9tAOxwwMsIFF+EMd0ItVwubfCs6e6C3Jw6GoujEc6acGW1yLwUYsi1oyJUY3XGWYD4UnP/6+m/0oMfCCf1ny9hBCnRG/My/V0upuxcsF2NuFEkrkZ0K70J4kNLNedRGBDDOkmXKI3nJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729766919; c=relaxed/simple;
	bh=eTM8WR4ymvU335IiWajnHw49skXLQTliF7Gq7kKFeyg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BMYvekq07xeBeN5E8QyB2cPJCY+wnXHBsSZqoyYHfRULfOKxwEyeP1vBDhZYekyWHTEFWiGj74LVbdZTF2dVkKe73aboaAxqOpqIM9+il87SYMWaQh68ClX5/AJ/nICgqVVV+AklhEB/1cmJX6lHdbNirGBoCJ6S9jNAwe7hMsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nGmtz81Y; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nGmtz81Y"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a99f646ff1bso95618566b.2;
        Thu, 24 Oct 2024 03:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729766916; x=1730371716; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2/W3bsSjAEjptFzOg30lRcHCSqSJmRxjkJmuxoViKng=;
        b=nGmtz81YoW92SWRRXZ2otWgVZDts9eXYCGvq5mtLraawG6Z0Y6DWvQ2MOSHZYnFm5C
         MPFihkzXkIExQz8Zet4a7q5Cx0V+iCRJO22k4Ls+S3/HkVxaMZNRZ4ogB0QnkXxsuCAU
         lzjBwxlS15DLGmKqJPp+yJwsq9m/3Qc6NDyW9dyL1ulIADBhWKU2iovlkcUfJe3t4Klw
         wHEFTLHTmpLAUDr/fevawXITDO9FDG88klDNHYyqd3Tg+6rITjjWkCXZX+6lqwzUHDin
         8Lt3x4/dXLbQVx0rCtNiRAko4oxir/x4ct9YCHDaZS1GmIE0MtaG3Brl30XgcQFxYoCP
         PgEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729766916; x=1730371716;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2/W3bsSjAEjptFzOg30lRcHCSqSJmRxjkJmuxoViKng=;
        b=inqEGGNiMiNUxYa84tru7xVsQs6Ttq1JSIvd1zWef+Za1EB4vxYySBQX6/EIjjIppd
         tjz5Uw3KcylItI4TlNe7j/uB19YkDoLXMsR9uqm1VFiu3elmYxqxsCA92/YlJeFGu02m
         GAlxkXy7os68BDiNxR9q6oZvMiLFsU6LvwrevutTkkW4aQoAMCdEOAxVgvTUXtRkYkoA
         kASj25JpSFg4GWIJmId6fpAYBrhIW2Sn39SlQESyIIBl9Vk0LvDVeOXaOMg62LzdbzvQ
         x37siryhiRmZWDeGL/sNOGUR0RNgLI90B1042l58XQkh+03puOrNWi3EYUgse1+puh2x
         0gfg==
X-Forwarded-Encrypted: i=1; AJvYcCW7Atb3m0En1axHFxQZpykd1eHuT4oEHJRxAfvXCtggReyvoLsHTlsmW5gVMyt1HtFbyQOzz4TVLIBH0S0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMp90iop9rCtp76fOvCJs4DhszbhAm2JuPh+HhyBky2AFHtZoz
	AHOEpFsWtBLAgkotbjZ6s+5A9pM6RloTCZogz1QN+dD1Pbo1rRez
X-Google-Smtp-Source: AGHT+IECtgYQoP38ohbf40NHWyudUidNo9gpAKYwjUt7WBrwDUfyOi3o2hAlbXverDz8xCGwqAKm2w==
X-Received: by 2002:a17:907:7288:b0:a9a:2a56:91e with SMTP id a640c23a62f3a-a9abf84aba4mr659823366b.6.1729766915449;
        Thu, 24 Oct 2024 03:48:35 -0700 (PDT)
Received: from ?IPV6:2a01:e11:5400:7400:4be9:6ab9:1062:7d2a? ([2a01:e11:5400:7400:4be9:6ab9:1062:7d2a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912f660dsm599344066b.80.2024.10.24.03.48.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 03:48:34 -0700 (PDT)
Message-ID: <be3e7378-7aec-4ebb-b6e6-e7b824452adb@gmail.com>
Date: Thu, 24 Oct 2024 12:48:30 +0200
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: Fix invalid shift in validate_sb_layout()
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
 skhan@linuxfoundation.org,
 syzbot+089fad5a3a5e77825426@syzkaller.appspotmail.com
References: <20241023213043.47846-2-gianf.trad@gmail.com>
From: Gianfranco Trad <gianf.trad@gmail.com>
Content-Language: en-US, it
In-Reply-To: <20241023213043.47846-2-gianf.trad@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23/10/24 23:30, Gianfranco Trad wrote:
> Add check on layout->sb_max_size_bits against BCH_SB_LAYOUT_SIZE_BITS_MAX
> to prevent UBSAN shift-out-of-bounds in validate_sb_layout().
> 
> Reported-by: syzbot+089fad5a3a5e77825426@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=089fad5a3a5e77825426
> Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")
> Tested-by: syzbot+089fad5a3a5e77825426@syzkaller.appspotmail.com
> Signed-off-by: Gianfranco Trad <gianf.trad@gmail.com>
> ---
>   fs/bcachefs/errcode.h  | 1 +
>   fs/bcachefs/super-io.c | 5 +++++
>   2 files changed, 6 insertions(+)
> 
> diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
> index 649263516ab1..b6cbd716000b 100644
> --- a/fs/bcachefs/errcode.h
> +++ b/fs/bcachefs/errcode.h
> @@ -222,6 +222,7 @@
>   	x(BCH_ERR_invalid_sb_layout,	invalid_sb_layout_type)			\
>   	x(BCH_ERR_invalid_sb_layout,	invalid_sb_layout_nr_superblocks)	\
>   	x(BCH_ERR_invalid_sb_layout,	invalid_sb_layout_superblocks_overlap)	\
> +	x(BCH_ERR_invalid_sb_layout,    invalid_sb_layout_sb_max_size_bits)     \
>   	x(BCH_ERR_invalid_sb,		invalid_sb_members_missing)		\
>   	x(BCH_ERR_invalid_sb,		invalid_sb_members)			\
>   	x(BCH_ERR_invalid_sb,		invalid_sb_disk_groups)			\
> diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
> index ce7410d72089..44d0ac9b00dd 100644
> --- a/fs/bcachefs/super-io.c
> +++ b/fs/bcachefs/super-io.c
> @@ -287,6 +287,11 @@ static int validate_sb_layout(struct bch_sb_layout *layout, struct printbuf *out
>   		return -BCH_ERR_invalid_sb_layout_nr_superblocks;
>   	}
>   
> +	if (layout->sb_max_size_bits > BCH_SB_LAYOUT_SIZE_BITS_MAX) {
> +		prt_printf(out, "Invalid superblock layout: max_size_bits too high");
> +		return -BCH_ERR_invalid_sb_layout_sb_max_size_bits;
> +	}
> +
>   	max_sectors = 1 << layout->sb_max_size_bits;
>   
>   	prev_offset = le64_to_cpu(layout->sb_offset[0]);

Wondering if this other patch might be considered more correct to 
prevent shift oob, given also [0]:

diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index ce7410d72089..428172897501 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -287,7 +287,7 @@ static int validate_sb_layout(struct bch_sb_layout 
*layout, struct printbuf *out
  		return -BCH_ERR_invalid_sb_layout_nr_superblocks;
  	}

-	max_sectors = 1 << layout->sb_max_size_bits;
+	max_sectors = 1 << min(BCH_SB_LAYOUT_SIZE_BITS_MAX, 
layout->sb_max_size_bits);

  	prev_offset = le64_to_cpu(layout->sb_offset[0]);

Also this patch was already tested by syzbot [1]

[0] 71dac2482ad3c8d4a8b8998a96751f009bad895f ("bcachefs: 
BCH_SB_LAYOUT_SIZE_BITS_MAX")
[1] https://syzkaller.appspot.com/x/log.txt?x=1640b640580000

Thanks for your time,

-- Gian





