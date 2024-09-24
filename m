Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D8D1B85C2
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Sep 2024 02:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727146106; cv=none; b=iqCODHYD7xTduD/4SckTtrs/Z3qZyYB9E60c9LyRau5DLXzWm3B6HNA3OPstFDSnVemuNZSFbkApgp4hpT/5zGaA2zdEkFukAEOBDwfljbYdn/oBU2PYIA/ptL6W1FNkgvBSBPSPTePOjGQtJ+OT6xNFOMdZekdItPE6PdUoF5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727146106; c=relaxed/simple;
	bh=eHzafNxabmGSIs26LY/np3HBRImQLK5VxqnoAlmffCQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sDJaV6Xm0l267gRJxYuJAMDW/kHgP72SwizTgzfx5z+fk+QXhNeRPG1efGxk1a1d2brR/qxpQRGfGBuKa3k2bvzhd5GGeGUXDYEqwbRoyB9pFb2KZIbvbsr9+xM3lm77xNqy9J2Y3En4xaEheSwPOBC7620INMNctXxPKW8hAd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PB494Vuv; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PB494Vuv"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5356aa9a0afso7819592e87.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 19:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1727146102; x=1727750902; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LRazYseFwv7HnZyxXE3fGsm1aCnICLJvDr/BBHvdERY=;
        b=PB494VuvmDiwjjQhMIkF43qMikkmeLUqsqwkt/vEIkhnNNc9RypO+9BFMU/wMFAvF1
         Rg5c9S2NxEXoGeqzWFBqGOMllgaSPpVs3k6AvE2ZQLaEhDZunqsm1Xdan+sO0OYsmoDp
         vKKVdydYB+uwhcXuFVAieco54jNJffyK9AhFM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727146102; x=1727750902;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LRazYseFwv7HnZyxXE3fGsm1aCnICLJvDr/BBHvdERY=;
        b=JHGghy4ZVr1VCXNNsbBQCroZgdPgYB/OjgtobgPabc8fx92hK6MLT7bN0qFcgJyS2J
         OOu5pMlDquuoEUMGv9Rwv7HMYHLGbo/O+78WnV9coHQKDcPOAXD43FZY1VmafU1PXRyI
         UeiuN98XrWF/JEPaOcln6WQTfr1wdvqRO7gNhNpx9CaE+TCA2zeHIspT8ooK/R9beUZP
         qxERVnIT686q4w8M3XYKy1nQLxWBi+mwNyHi4S55GT1imCmEzgIDHungVRjGAzJctPIh
         aOwSHOpfqISzQTYX01sGDhJaX8OcG3ggTnEpNGjFHYvNen3Z22cBVCZX0kwY8+1F0HBS
         vz/A==
X-Forwarded-Encrypted: i=1; AJvYcCWwZU3c99S9Tz2tGkCy7G4LsXiuHNOI2SrVhD1DX2qdccGmV3joDeubfCkPucV8SFEMLPOLBdUd+0oOBl1UhQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxvL+y49e/TXM+gsMW1GGxgIREB0GPdQs6SfmRFVHnbZ1fyGZ3+
	pkKyLMpsY4NFHOn38H8WFKWAqsG6docXLqPWRsBRdmE9PZNoFVviNt0X28fQlXmFnqGFz6Bjibp
	GxIXaeg==
X-Google-Smtp-Source: AGHT+IFedccuiegtVxK/Nz5zLNMQYSaGxDQgT8UChQqJFs2hcbO+JhFB/uw0ilcQ9I6jmfgFC5FFCg==
X-Received: by 2002:a05:6512:1095:b0:530:e0fd:4a97 with SMTP id 2adb3069b0e04-536ac17ba54mr9463676e87.0.1727146101720;
        Mon, 23 Sep 2024 19:48:21 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-537a85e0bf9sm65694e87.37.2024.09.23.19.48.20
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2024 19:48:20 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5365a9574b6so6951966e87.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 19:48:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUFG1hLDAmnE1QaG1JEWgFcgcgRuhtia0OrsuPbLPL7b13+TFcJ9Ri7ZcJTETBZB92dfhd91rldU/pxYFn02Q==@vger.kernel.org
X-Received: by 2002:a05:6512:1095:b0:530:e0fd:4a97 with SMTP id
 2adb3069b0e04-536ac17ba54mr9463642e87.0.1727146100293; Mon, 23 Sep 2024
 19:48:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <dtolpfivc4fvdfbqgmljygycyqfqoranpsjty4sle7ouydycez@aw7v34oibdhm>
 <CAHk-=whQTx4xmWp9nGiFofSC-T0U_zfZ9L8yt9mG5Qvx8w=_RQ@mail.gmail.com>
 <6vizzdoktqzzkyyvxqupr6jgzqcd4cclc24pujgx53irxtsy4h@lzevj646ccmg>
 <ZvIHUL+3iO3ZXtw7@dread.disaster.area> <CAHk-=whbD0zwn-0RMNdgAw-8wjVJFQh4o_hGqffazAiW7DwXSQ@mail.gmail.com>
In-Reply-To: <CAHk-=whbD0zwn-0RMNdgAw-8wjVJFQh4o_hGqffazAiW7DwXSQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Sep 2024 19:48:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh+atcBWa34mDdG1bFGRc28eJas3tP+9QrYXX6C7BX0JQ@mail.gmail.com>
Message-ID: <CAHk-=wh+atcBWa34mDdG1bFGRc28eJas3tP+9QrYXX6C7BX0JQ@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs changes for 6.12-rc1
To: Dave Chinner <david@fromorbit.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dave Chinner <dchinner@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 23 Sept 2024 at 19:26, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And I had missed the issue with PREEMPT_RT and the fact that right now
> the inode hash lock is outside the inode lock, which is problematic.

.. although I guess that could be solved by just making the spinlock
be external to the hash list, rather than part of the list like
list_bh.

You wouldn't need to do one lock per list head, you could just do some
grouping of the hash.

That said, the vfs inode hash code really is pretty disgusting and has
been accumulating these warts for a long time. So maybe a "filesystems
do their own thing" together with some helper infrastructure (like
using rhashtable) is actually the right thing to do.

              Linus
