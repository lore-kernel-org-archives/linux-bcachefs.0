Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC364C79
	for <linux-bcachefs@vger.kernel.org>; Fri, 20 Jun 2025 00:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750380699; cv=none; b=EcG8keF54LhSSsRtPpl9OhlNmSbiinMvO7kll5aCzSJ2LyGSM8HJx1sEiUfVuKkBzhY5xmzjh6bTnLwtufAEe7SoAyOXvmSRuga9l7JKTiS4sAyPo4tJZ8gbHuai6BqvF+9oRh3tckR8McAQZxxZCcpv8oRGjmH8OTKsHcBf7kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750380699; c=relaxed/simple;
	bh=XBfHEcK0mWjYsnnj8nv9sCwT1bjoUaVhc1XilYY5l2Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ITlT0A1F9Tbx5F5kQXRRKUP/kujdKMAF0CqQyU5XhVDWd0tf3kZO4GZUHKLAwUtrRUR9AuDJpna7Lzc34CiJBeTch4Zhxt2/16t7bHcZFrcBN5TlGYTagDFak5IZSyg5hFASDLY8f+V5nE41Ir6TEkLt1FHnQckHfonEszM44/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZnMK5G+A; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZnMK5G+A"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-adb47e0644dso232180766b.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Jun 2025 17:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1750380695; x=1750985495; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=amCKKTK7Xfm9vaiLtnNoWf+4gB9P6Ypa7zFByBfugqE=;
        b=ZnMK5G+A+WEyalYQwt6JJpcaXysCvoia/8R/4lxRVhmsdzlQe4pnji9hPimg0B92b5
         cs8Vd8ETAyI8J8gPskDBALJ8qYGeuC4Zp7NFB/rw/e9W5Z23TFRM4rnTmeiH2IkKtXXc
         e07+0f1vbS4EE1B6U8dRGaXIiJahM6TLHAmDI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750380695; x=1750985495;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=amCKKTK7Xfm9vaiLtnNoWf+4gB9P6Ypa7zFByBfugqE=;
        b=gB5o3hHP1ZfqNXSR6euPWp22UxsOwziJNcVj9laJ2bfLWFYH/hLdDRV7habvNIcMQ8
         vyZvo80bESLg7kqUFa2aiV6UfDWi6ekH2ejKfUuK5N0Yh01UKkbm99kgBNcCM2Bfak68
         XCdoDXZIH1MnE67VycUe9/QaGdgcSpAxIRpnoV1/RIRdmrPd64/tFYNdD72eBJpLDjww
         mOWJXRlzD8debmxZpbv6zI0s7jpCNe6/owK3RtcYj6iMhvlLIZh+oTEObzNZnKudn7vS
         zJRNejOYyop3mcmWE3cs4AYfvxtM+5tm6kFL9qUxzixdHOQm62Gmzzs5c1K71/Krjpv5
         EyYg==
X-Gm-Message-State: AOJu0YxnjBATxKLZuwrG3okSMpCQwyjcHbsOyk/uK0GnLIwOtLgTkGaS
	uBXQsUVCW1gq6YGalYbXKSa+8Av8faUKKFE42zmVSXpqntcFKnVU76L0etYusNvTvCaf1fmTx3w
	pKIVh3SM=
X-Gm-Gg: ASbGncu6UeAChV0IglawDy8TZi1y9/6ysljzfR8l0omjZ4KUrjV0hk88E40ZM04Fuej
	Y5cAUJNEcoOZlVq8krYAfh1ViFjPTp+lNdGNUkaS81FuMKYNP9ehNUiObs+HfmJ0qg/wfDu8FMh
	wcNgqhADhCVdQvKZg/tNAkYBN6DlVLpfkGfB9m90ohFVzkta2kOLy0XhPlzSa7zZAlo3OQm9YBa
	CdTPhzFglyZ+vbSupP1VbwuM/zVQVZRh3ziR0o8Ggv6hfmx8dx8n2iRwClzrpWV4Ne9a/CL9qpR
	/FvCbg/qfQTkippgul1b26VEhtC4LrTaYhsFTy/VIoMiNxUlEnAKxUSupls/uwZolZiY85Qp4d6
	KTHKimgu4RYdisKMsThH9fk/lzqltxrqCHhVs
X-Google-Smtp-Source: AGHT+IGAQ27XE/KgmXeV6qTjkTU/8pzlEFCzZaEBasqAPPrXeR9IptD2GJyq/HBK4UJ1g03G7lvD4A==
X-Received: by 2002:a17:907:2da9:b0:ade:9249:25dd with SMTP id a640c23a62f3a-ae05ae1fb69mr40767466b.8.1750380694979;
        Thu, 19 Jun 2025 17:51:34 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae0541b6894sm70725166b.111.2025.06.19.17.51.34
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jun 2025 17:51:34 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ade58ef47c0so271789666b.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Jun 2025 17:51:34 -0700 (PDT)
X-Received: by 2002:a17:907:3cd4:b0:ad8:93f6:6637 with SMTP id
 a640c23a62f3a-ae05aff9d00mr27360766b.21.1750380693794; Thu, 19 Jun 2025
 17:51:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4xkggoquxqprvphz2hwnir7nnuygeybf2xzpr5a4qtj4cko6fk@dlrov4usdlzm>
In-Reply-To: <4xkggoquxqprvphz2hwnir7nnuygeybf2xzpr5a4qtj4cko6fk@dlrov4usdlzm>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Jun 2025 17:51:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi2ae794_MyuW1XJAR64RDkDLUsRHvSemuWAkO6T45=YA@mail.gmail.com>
X-Gm-Features: AX0GCFuhpreW8drYXdBOfJBDTA2DYta__fpckLTs4pxLGozxz1PdEwH2JifGeHE
Message-ID: <CAHk-=wi2ae794_MyuW1XJAR64RDkDLUsRHvSemuWAkO6T45=YA@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.16-rc3
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 19 Jun 2025 at 16:06, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> - New option: journal_rewind
>
>   This lets the entire filesystem be reset to an earlier point in time.
>
>   Note that this is only a disaster recovery tool, and right now there
>   are major caveats to using it (discards should be disabled, in
>   particular), but it successfully restored the filesystem of one of the
>   users who was bit by the subvolume deletion bug and didn't have
>   backups. I'll likely be making some changes to the discard path in the
>   future to make this a reliable recovery tool.

You seem to have forgotten what the point of the merge window was again.

We don't start adding new features just because you found other bugs.

I remain steadfastly convinced that anybody who uses bcachefs is
expecting it to be experimental. They had better.

Make the -rc fixes be pure fixes.

                Linus
