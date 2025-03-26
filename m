Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997491F4193;
	Wed, 26 Mar 2025 15:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743004174; cv=none; b=iQQiTOx4zgR0Bq0j+BiD7UAFk1BYMtt3idTxpEMCf3MmZ6cibYdLDC5Lm5bbcspovEboqT6saikpz9rEGD+XyQ5TbajJOE8j8ePAf+UolOfSv7f9WYoLLBeP4X3Fb5hbacobdB4tMgzqEIJRLff5vhx/fMY7VVPOzSii7FbbCKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743004174; c=relaxed/simple;
	bh=xfSoNr3eqnJ5RCwTzb37h1PBTjnHv67iKD5bQpessBA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RgKvLmzsdPwRKjlkyLivSWw0zvLsAScjP/lo2ychftsueVQPhkP95PsCx8XF78iNEQq6aE0XI3MRsF7SRXxSyD3Xonu66edIIuUS4ChFMB+EXPQdHDcBNBLfSZHQOpjYF5HKd2JLAMuGMMKCi/ElPaMaO7AaWH/QedkBjyf4aA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K9CpQS2T; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K9CpQS2T"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2ff784dc055so11821000a91.1;
        Wed, 26 Mar 2025 08:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743004173; x=1743608973; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xfSoNr3eqnJ5RCwTzb37h1PBTjnHv67iKD5bQpessBA=;
        b=K9CpQS2Tj5XLTTWSmNejfjizJxcxj4yE41Oe3g/iyJ+2eoD/FHb/rfrol5rGJLo/s4
         y0lyp16RqEDk6ji3Lk2+xL0ajuGI80rl7kXu3gs1hLDqYNFe2UO1v9w0hMa4tkvZuZSi
         cjDUMSiMq6kf2cacKe8m2N1w1cYKUsj63pXxg8Rbq3FAdRyEctXkArMiN/W+tqi8HUbE
         p0GO4cT+48aNdMnUw0AElXUEjTpMsxa85vX5ZnD1c1yKkoYb0UaRCnTBQ9PXEK8AHD77
         VYDHdv8xUylLT+BGssv2igfxJczm1W1gdT2tTX7YAt1xwN2y9alGkcOU5F6SDmmyGAKP
         VdKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743004173; x=1743608973;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xfSoNr3eqnJ5RCwTzb37h1PBTjnHv67iKD5bQpessBA=;
        b=t1091vjeHac8GlCmyk69MdFalFHY2ittXhJnyXytlVtvlhcfLvQCxp2iyFA1q9Q2YC
         lhnUQ/ScwaL4+2xtiTzzhPxkczJHWonxS17zHtNll1D4qne9X7qdFqGaLEkxio6NyAmN
         Pn4A/CHPXV8MAyyVaTUL4Z5Yq7ou3gc+1RIXdVb5u82vhXAhOJcFBYl5mRSwivAM8iDb
         3ERDinXc+y/pMMHfbvt2QbOf1rF6QdNsi8HaOI9+MWM11gWia/Up5pW0FokNFIv58h5b
         wuauREUgX1fWMHA0NfbAWncnS8uQohZLVd5fDoE3zPGo9c/uppynw0C5205vY/8ikPB1
         zxmg==
X-Forwarded-Encrypted: i=1; AJvYcCUog5kphQgN2/ddCSoxSvI+wQFJhmnHRSFk403THatC0CnUM6qQoviu6himS5L3+a7HWJay4hNPHzZAcp2qIw==@vger.kernel.org, AJvYcCV1rjpXj8jiSuNCQJEO3flX1MzY6we/OxoTxLxCRiS31Cx0MV6ATvvoQ3CW84uOtEDM4CwjcxBACU44VKvx@vger.kernel.org
X-Gm-Message-State: AOJu0YyG2ZYuI4eFWgArTpTfkJt0rBX7/looSBGbsfiQZdQxVJ62VqrL
	g16p1bzIaJAwYNHXGHUxPIb90qoTbBijJbEpvSV0LcvybxbrbbKO+XxhocVnAQHUL3XmcPWaNj6
	0iqEf4WMBq3LerBb2ZsU0/eiQP7Q=
X-Gm-Gg: ASbGnct0+hQdKEpgx6WATEiVxhZv9H8fnCzvd4LQ05CgjClR+lK1CJ5Xc+rbGDTNRvk
	St0iqQ1Rs05xxsPABo9/t+Kpk10VecvZ6xtMQk+UHpz6ieMXhWfy/zn0F7yqTbpr687uVLhCHIQ
	FHVMY1OafsHB0TSDzXYFq/CrJA
X-Google-Smtp-Source: AGHT+IEHeDe2/t1HeJOiCWOApTTyYC+oMi5AxQ80vsD09PwyUp2vhgb4tzUOmzkLr6YV8c2tHV1fPyQSpWz4c/i1Z3o=
X-Received: by 2002:a17:90a:fc48:b0:2ee:8430:b831 with SMTP id
 98e67ed59e1d1-303a7c549c7mr287126a91.2.1743004172648; Wed, 26 Mar 2025
 08:49:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250326094449.16473-1-nicolescu.roxana@protonmail.com>
 <5F3AB2BC-43DA-47A6-A07A-72540B327D11@gmail.com> <bmjvipermsvb454mdh5zmlmw4gv4oub5fgh4eowedlit75gqei@3or3va3e52ce>
 <MnHJR6KH9EcCqnLtdxKf3XYBSQQbvXWJafG28O2C2itnS_eETVFoDMfVvFva3dkLMZ-LPRWUhG2g_5HBY_lPZkWOYW2aOg_T4YWTrzXmVZ0=@protonmail.com>
 <wdagx2vwyv7s2t2tcndwmambwdhmoitvhmnzcopdl3xkfq6ct2@evmzpxnuhi4e>
In-Reply-To: <wdagx2vwyv7s2t2tcndwmambwdhmoitvhmnzcopdl3xkfq6ct2@evmzpxnuhi4e>
From: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
Date: Wed, 26 Mar 2025 21:19:06 +0530
X-Gm-Features: AQ5f1Jr8G5tcVn1-xgCNxwIlPj-jIruCZ0MdYwdAXH_uPIFPKUaVk9tvv8O1vPs
Message-ID: <CAPZ5DTF+Q_-10xF915wF3b3aUm5jqZepqoyivF+G4S6ONf_PcQ@mail.gmail.com>
Subject: Re: [PATCH] bcachefs: replace deprecated strncpy() with strscpy()
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Roxana Nicolescu <nicolescu.roxana@protonmail.com>, Alan Huang <mmpgouride@gmail.com>, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 26, 2025 at 8:22=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
> Or better, a new helper: when we're copying to a fixed size buffer we
> really want to zero out the rest of the buffer - we don't just want a
> single terminating nul.

I believe strscpy_pad does this?

https://docs.kernel.org/core-api/kernel-api.html#c.strscpy_pad
