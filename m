Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C90F2036E2
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Nov 2024 17:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730915586; cv=none; b=TO2sVLH2V1tryaeE0nScB1Mzy3l2EL7UTsstN1nYCB5+O0Nl1WzwPrNAPRT4IUBOyaKmYw79rq5nNSwvCCm5qxm1kef//XjzQjaL//nD3vaYZ3e8wFUVxWzZa6ncmy0Kovy/w++qardgooUGf1Z8cnuepZpvvmNGXDvdOBrf7so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730915586; c=relaxed/simple;
	bh=KC79F8AAKN9zqsEsq8PEeOTMFX475VCxxZ6E4T2vDxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zi5iCqxIP8K73yliWM9w3teUk5M1WFLmZYZ/SPWPZyIskTcE9GnWgMjGq2YOurZJ83zFN0Ny8mqprAzEjBJLjurlsiMl7giYDjWu8NCODq1dGwgHhWhmUPmnSIlbRLUSKGmZpX3ShpVq1eW+SySr8GklXZESQyJcHDm9DDk+eMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nVTr1xfu; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nVTr1xfu"
Date: Wed, 6 Nov 2024 12:52:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730915581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QRUJHFqF+m0efCjGnDS9+jrRg248YsINL1Mb2R1+v28=;
	b=nVTr1xfu8w6uQJeTqK9x2ouT757pOCHXirpVgAkH/sc7TXR7+0wgV5PAH5eV7X5R6MwAqM
	BcCOFGgQjcqbqQvV/6yd0Ixv3+LPnM02BOpeuwNAfs4psecHTRPY1UL8Gyuem77X3zCPIH
	0OBZ4p46ce0Ri4XHLvXgu/RrI9tLPD0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Piotr Zalewski <pZ010001011111@proton.me>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, syzbot+bee87a0c3291c06aa8c6@syzkaller.appspotmail.com
Subject: Re: [PATCH] Fix wrong max check in bch2_opt_validate
Message-ID: <v5wttxaimwpqb5jfpxvcs3rmg27fm4mf7446slutl7ztha6q4p@434ppx3gzv7l>
References: <20241031231823.688918-2-pZ010001011111@proton.me>
 <pkxqQnSTQLReyYEHegx90LNp5dbR6LlpcqUIkBFa2CiL-0P48QWpGJ1YYKtWwu0IFM7H-2T4fYQz0MldP6OqZppPzmqafQDKouhETLnM5o4=@proton.me>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pkxqQnSTQLReyYEHegx90LNp5dbR6LlpcqUIkBFa2CiL-0P48QWpGJ1YYKtWwu0IFM7H-2T4fYQz0MldP6OqZppPzmqafQDKouhETLnM5o4=@proton.me>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 06, 2024 at 08:11:13AM +0000, Piotr Zalewski wrote:
> Hi Kent,
> 
> Did you see this?

Whoops, I did miss it the first time.

I think it'd be better to fix it in the OPT_STR() macro though.
