Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0A415B0F9
	for <linux-bcachefs@vger.kernel.org>; Thu,  1 Feb 2024 10:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706781636; cv=none; b=SE6GOBsJ/6a4HVJAxTQS9bphl/3HBsYxb8OucTwaXh/0l+UOk5S3Biqvyo9nZYrOvh5PD3iBfzgsLPiNYoSP+sqXRSV5sikBdclUloSHCmmx9qbBCGFDYkRYYDSiBi70f2fMgvBCH2zsqV7uqTp+ebQGgcIXGG2mdjGdOkS6gi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706781636; c=relaxed/simple;
	bh=8e272kMnyr1BsycMZ2FxSdPkeCgmXf8RC9aJ4fe5K7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OGnziRa+jfGmQfJhn4aP+ivKW7Rmxl3WhWrTjBWwMZ4w4NqFWGu528xGCnDD9sUvkMr6p2ekzJiXcc3nPWF/4as+AJz4wA+CSUFgRNt+9DPngIWn5CM38YYR9+evRCvD4fXkPIOSAquR2IKKHUlEDrRl8NNwRuy0Aq2cjOKm44U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rqaeHEoB; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rqaeHEoB"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a34c5ca2537so92002466b.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 01 Feb 2024 02:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706781633; x=1707386433; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KHfEjt9Rq9BDLjwdJayCDbrptp97+8N9ZY8belPywYA=;
        b=rqaeHEoB5Psg+3TAsTjpscbIkY9V5bCVE6sjVFa4yurhuUBTG9nymaFAscDWZ8Yl9A
         Ksdmms2aJ0RsPJCAVK9ZBBnd7wn4n1k311zj0uLdS0aB03cDEAcbaus0aOGKz14rber7
         5u4fUDMt2N4yDsIHJJ3gaR5r+yGIZs1gpseCl3GC1nRmXgQd0f2Uuz64Fz9yopkzxccH
         D8yjJyL6JTqyrt1XUiqoQ6vFMW/fH3Xlppgevdrqj8HNmQ9/I66Hr1EiqpDVCO59I7fH
         sqluJvAlMMndtGdbJakdYCeB5l8e41/CFchP+Knk8EL3km42smbn5o4Tb1yQwspRfcG6
         cHRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706781633; x=1707386433;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KHfEjt9Rq9BDLjwdJayCDbrptp97+8N9ZY8belPywYA=;
        b=KUOgNYvX5/MuqsdSvN6EMvHk08iUbM69uf93LzK5+7IZx1bFUGRKUzPyNRQbsSnofv
         2/OEYFiA6LrgzSqPzg3V8fe0W7yGYXFvg/qFe6ZxKocfHd6YTbVjJV7TAlOTOreR3hub
         QXW5iRC9wzQVGIaclA6o0BwMKSVW5dT0Ow6VFRo/MwuYN4IN2Ysdu7Vldhsb0vixV2L/
         a3wkONGN4dCDEtHjE9O2CHsnYLUpArMoDUOI0jAxa36qQKEYRfDr+rBw9JAeJgX5aOPH
         m+1UmfPJsjTCEgAVPhhcUYkxxzWAXc+BmdES9441TZLD2EI0eiSsbuQht4RyuQIOh53Z
         qpVA==
X-Gm-Message-State: AOJu0YzBuK46JATD4d8bnqiNF1AW7/kn9x3+F+g2SBjFGZe0Kbqedz7o
	38K2VEnyICV/Jtl3feIdetISML4Xo5irXyMK85jbkYv9JpC7nhF3boSI8DsTvNw=
X-Google-Smtp-Source: AGHT+IH/fMQeezT+Ubyaw7OuZFel7mFCZYbVqfQf6KRvvWIRyX3dxS4wMaPi9O0Yl4SWGaCc8TIzUA==
X-Received: by 2002:a17:907:bb8d:b0:a35:a3e2:edcc with SMTP id xo13-20020a170907bb8d00b00a35a3e2edccmr2917823ejc.48.1706781633059;
        Thu, 01 Feb 2024 02:00:33 -0800 (PST)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id r26-20020a170906c29a00b00a35cb514aaesm3900016ejz.82.2024.02.01.02.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 02:00:32 -0800 (PST)
Date: Thu, 1 Feb 2024 13:00:10 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: kent.overstreet@gmail.com, linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: missing error checks for
 bio_alloc_bioset()
Message-ID: <a1d5fc7c-87ac-45f5-8f3d-5af1b7cd3614@moroto.mountain>
References: <0c35596b-a280-40df-946c-c50574c3ce26@moroto.mountain>
 <fufpv24643xxn3a5jpfxx4wbfwlczrhjyzqkxo33be3yeb4sea@y4obfahio6ag>
 <11e692bc-4077-4e82-b680-fa86182d15d9@moroto.mountain>
 <34p5j77iamkybfexdpjslxegy74da7mjtpsssrv4mems4bo5mj@5xlpdnvm4yxz>
 <e92fc993-ab94-4f3b-9ee2-4e0ca5341720@moroto.mountain>
 <uxyjkjzbur2unpdkt5yl2bojacg4tptfj6k4zyshcyvyfun3i7@y6q267iebdgg>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <uxyjkjzbur2unpdkt5yl2bojacg4tptfj6k4zyshcyvyfun3i7@y6q267iebdgg>

This email thread has gone very badly and I'm definitely 50% responsible
for that.  I apologize.

On Wed, Jan 31, 2024 at 01:57:58PM -0500, Kent Overstreet wrote:
> On Wed, Jan 31, 2024 at 09:43:14PM +0300, Dan Carpenter wrote:
>
> > Come on Kent, don't pretend like I haven't pointed out over a dozen
> > bcachefs bugs since it was merged...  I'm just saying the comments
> > weren't obvious here.
> 
> Most of them weren't real bugs, just places where I tweaked the code to
> please the static analyzer; I believe the number of actual bugs was more
> like 3-4.
> 

That's not true...  I really try avoiding make the static checker happy
patches.

The only one I see which was obviously just to make the checker happy
is commit 4b33a1916a35 ("bcachefs: bch2_ioctl_disk_resize_journal():
check for integer truncation") here was my bug report for that:
https://lore.kernel.org/all/3b879f4f-2fe4-4e0f-aeeb-1d5a62d0a1ce@moroto.mountain/

There were three other patches where it was like we have an "if (ret)"
but the "ret = " assignment was accidentally left off, but I consider
those real bugs because obviously the "ret = " assignment wasn't left
off deliberately.

Here is the whole list.

$ git log --oneline --grep=Carpenter fs/bcachefs/
03cc1e67a243 bcachefs: Fix null ptr deref in bch2_backpointer_get_node()
97ecc23632fa bcachefs: Fix strndup_user() error checking
cfda31c03315 bcachefs: drop journal lock before calling journal_write
4b33a1916a35 bcachefs: bch2_ioctl_disk_resize_journal(): check for integer truncation
75e0c4789b62 bcachefs: Fix error checks in bch2_chacha_encrypt_key()
a55fc65eb2c7 bcachefs: Fix an overflow check
f7f6943a8c6d bcachefs: Fix copy_to_user() usage in flush_buf()
d67a72bfc92b bcachefs: snapshot: Add missing assignment in bch2_delete_dead_snapshots()
1f12900ab523 bcachefs: fs-ioctl: Fix copy_to_user() error code
b6c22147e0fc bcachefs: acl: Add missing check in bch2_acl_chmod()
e9a0a26ed05a bcachefs: acl: Uninitialized variable in bch2_acl_chmod()
867c1fe0187f bcachefs: fix error checking in bch2_fs_alloc()
4ba985b84de6 bcachefs: chardev: fix an integer overflow (32 bit only)
301e0237cadf bcachefs: chardev: return -EFAULT if copy_to_user() fails

regards,
dan carpenter
