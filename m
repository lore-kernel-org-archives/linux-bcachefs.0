Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C8B50263
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Jun 2024 18:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717785837; cv=none; b=WX0XQyvfKCU8XRWuydH8X7wKMYSmYGfOpvtThRPyHwJpuwhMLQWPpVcBV3rPUPhnmxQrL00uFOyVL6sGAgfpsXwb6ImO3VlpEN3IFxDkv5XN6WknOEE73vCuIOLwkJ/IE1Kw2Klymyw8af4g3/Zvv8zaNQBU90X4/IXNmBOcQfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717785837; c=relaxed/simple;
	bh=YWh/DsgEn1BaFL0EqkWp5j41UDYQVCmCiGHySHEPazc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dG6HINiS4/J4eCo4VGjaq7IZTxOeNkBRZzs7lLHcv3Ut4L/tSk1141femO4BoyYu3lZLhiR6bqOtzQqegdQvrkiua5j3r6CR1M/X/5W9xtCzK9baJ2Zf3sNTMlXdHoaupKBGJwMTDfzwCSJgdxRlXGs0nEwmaDaxhwH6y0mErYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Z2L2Gv1X; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Z2L2Gv1X"
X-Envelope-To: mjguzik@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717785832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YWh/DsgEn1BaFL0EqkWp5j41UDYQVCmCiGHySHEPazc=;
	b=Z2L2Gv1Xai9bBWY5tKev7f/NSFmGCWbnGbLWYg862LpnvWik35TiZBtxL5LohT4SQCEIsK
	F/Nl7dNTl6Ycqy2UX0URxdoPmzLrB19zh4UGAUWrv9E9/xt4w4xgONV4YA2ZHN3wXz+oIg
	gcblaHBfd3AhIRw+pM7UaqDufyjAA6Y=
X-Envelope-To: linux-bcachefs@vger.kernel.org
Date: Fri, 7 Jun 2024 14:43:49 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
Message-ID: <3pfkkl4ig6jzdfh7bu5y3hb7jbhzlumtzrk4syi5kunmr5vjov@7jtnnr35dlh5>
References: <y3qdwfh7gjs6ykedg4ehrbwsiktabbtgoqloka5nnj5oatkh5k@7evginr2jhsf>
 <CAGudoHEsFHMG5UYpSyobp1zpm-eOpKdx=b7kL9NFG3_VKE8+Zg@mail.gmail.com>
 <ln4mfb5iv4kxxjcpm67szq24g6dxfdk36fsxb7shojmhg2fkf2@izeciivj46yw>
 <CAGudoHGeak9cnG+qE6=zoqbg5KiOZG+aMHksmbvwWTATKhWm-w@mail.gmail.com>
 <CAGudoHFyJ64SDwUTijSrqeDjXBO3MfFx8D8-DoMaPFEQmzzLDw@mail.gmail.com>
 <wvpgfberqgnidhzymc5gxsa45vwtrcto45ppcx6bprar5bkg4u@6tmfvbp5xeac>
 <CAGudoHFDFgAq2--dEubAV4w2ZqdqNY56SdAmmvy1nF8Z5bX6kA@mail.gmail.com>
 <jsrnek56sgp3stom6nmkfkacsva3iphl2hbmohece2htyrtt7l@hlbezgwrf3hk>
 <CAGudoHHwAC5adU6p6yM_mwrwGzDDQLn8ES985X08kY==+juAFg@mail.gmail.com>
 <CAGudoHEcZtQ6w7vECoV3Jk+oWA_ejHdtbN2VpmR0qPPN+9-X5Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGudoHEcZtQ6w7vECoV3Jk+oWA_ejHdtbN2VpmR0qPPN+9-X5Q@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 07, 2024 at 08:28:07PM +0200, Mateusz Guzik wrote:
> Well I did a quick skim through, it's probably a no-go:
> 1. uses bit locks which i'm told would be problematic vs lockdep and
> rt kernels (see the original patchset by Dave Chinner, linked in my
> fsdevel post)

The bit spinlocks are confined to the rhashtable code; they're fine.

> 2. insertions can fail with ENOMEM? for this particular usage that is
> very iffy to me, but i don't have a voting power in linux vfs

Inode allocation can fail with -ENOMEM, so that's also fine.
