Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4806D1CD01
	for <linux-bcachefs@vger.kernel.org>; Tue, 16 Jan 2024 17:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705427962; cv=none; b=RbNBdlmoXlV6dV5SrvtoY7rnRQYStI0YgrbLm6WzkmHFlXqSno+I7DCWa77HDTZE+BV6cjYfOlcRM1CxcIA1RAuM7tfEpxbzIvlq4irJiQAERw0z5L5ocNxv0ZQw9u/KVaFl+Kn/y0FG+lDb6AVeYrLOGXh67YriEYZcx8EIXeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705427962; c=relaxed/simple;
	bh=50KlTrqyhw54FGP2KO3WOv+8Up6jkmgXBu6ZAou9uD4=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:MIME-Version:
	 From:Date:Message-ID:Subject:To:Cc:Content-Type; b=uW+Pf6WjaVrevsiDHvlcAVtqMgTlIwZ/14OSQYA5RQsWwmVJbtKPrDo2x7rsKeGcntteqw8JxEeEi4tq7klafHkmkBn+hnD9cNCHrsMLbNmyHAhEgNcPeNczOIAoj/dhv86q9+5SG7xr9j3aJ3Hm8yP4SXfuXm4q5aRHL2LapvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RpZK3zKB; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RpZK3zKB"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a2cad931c50so473448866b.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 16 Jan 2024 09:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705427959; x=1706032759; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MBTNOaN4DXd3keYaYvkuQYggkZr2IqjDV5S1780Vw8c=;
        b=RpZK3zKBqIIort08aQfQ2x5yyUw7nc2hFb1Qei5x6PpcVhUFQM3FH5uxIBnz4ehw/u
         MsaVAvj7LTokRe4q4g7TpbI8R+25WYSQ5QHbg1Cn9F7hguXH1Pt4L1ujQ+hN9r3JbOT9
         4GHRRBouUeBaKZ3R1TkyQpT4rHC7oR0Zd0IAo8xiNzzHHxtT4mkBNxZPwV4fObLRj2b8
         TbY2bnty4vawsbPKChRQqvBZ3InIvXRfVxCCE3rTNva1D+kaEBemD/isnc/oQ1sdC6ej
         6J7dZfLggD3faKfdRYDF+jB4AMktuwtd1zSnGRPvLQ32iatfGUY7UxCur4KwkGl/D3jp
         7Vfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705427959; x=1706032759;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MBTNOaN4DXd3keYaYvkuQYggkZr2IqjDV5S1780Vw8c=;
        b=fRHIGT5lqY3x0HhkJpUx7zH7GaiIiLMYvSq/VTQfehkWg1sIf3XvXPe/W+qxq+t3Gg
         +odGMe/RwLTKSgJi/95LsAAUlnSB8YdkYWxOG/3IS7INZdHFIYyL2wEAe4l6N4iL1t+J
         isehgFAdzX9CtZTP/Oaklce4iGRU0+ZeO+Bjo1WAcVmQNlepyjvjZT7plyhA++VVmdMx
         GEg/pzwEBiD/DODU+Nm7FGEMELzm65A1TbxZ+bWwm6nI/hjkhx6KWfqzWH+lKG1noNSu
         6+SxfUvopeTDeyRl2bumvpSXsoiREM+J/Zu6LMhgMJjhIh8qDMM8fcx81ovw/EnyOgKO
         kntg==
X-Gm-Message-State: AOJu0YwaN0zm2gqWYoCnKmkwC5qniShQcIBV3vhEd/SsiJAQTn9d7Y3s
	4QmWPK4b/5oWJEfFZz47E11ApZ9W1Ti1kXuSZS8=
X-Google-Smtp-Source: AGHT+IFktxqg3QVgc4QlsXaNg0CyweSTY6Nd0cRDRogxAI/U9eeWSXQzRlnyl2ypZRpnpjIdmBas+1p1iIvczaR04q0=
X-Received: by 2002:a17:907:a4c:b0:a27:941f:32a1 with SMTP id
 be12-20020a1709070a4c00b00a27941f32a1mr4491110ejc.58.1705427959306; Tue, 16
 Jan 2024 09:59:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: George Hilliard <thirtythreeforty@gmail.com>
Date: Tue, 16 Jan 2024 11:59:08 -0600
Message-ID: <CACmrr9gQeXccyS9ZRiR2KnTKnA6EVBCVz_YWcDC3p1mbGqgMSg@mail.gmail.com>
Subject: Re: Error while unlocking encrypted BCacheFS: Required key not available
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org, lkml@inml.grue.cc, martin@lichtvoll.de
Content-Type: text/plain; charset="UTF-8"

> The keyring stuff has been a perpetual utter headache.
>
> I've been debating rewriting that stuff to just pass a memfd handle as a
> mount option and rip out keyring usage...
>
> alternately - now that we're pretty much always mounting via the mount
> helper, perhaps it would be a little bit less fragile if the mount
> helper was adding the key to the keyring - that might be worth checking.

I am hitting this exact issue with the same exact baffling behavior (bcachefs
format, keyctl list, bcachefs mount -> fails). I'm on Arch with Linux
6.7.0-arch3-1
and bcachefs-tools 3:1.4.1-1.

Some other folks have found similar problems with other uses of keyctl, see [1].
It appears systemd segments each system service into its own kernel keyring.
Presumably the one bcachefs-tools is writing into, is not the one the kernel is
reading during mount.

The workaround for users is to run:

    keyctl link @u @s

just before running `bcachefs mount`.

I am not enough of an expert with kernel keyrings to know whether the kernel
code, systemd, Arch's packaging, or something else is at fault here.

- George

[1]: https://github.com/NixOS/nixpkgs/issues/32279
