Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FCAEBE
	for <linux-bcachefs@vger.kernel.org>; Mon, 11 Mar 2024 02:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710123433; cv=none; b=u/5ZXNhQcEMwS6RqyJHDty8u5/2QQZiFRhQxqKxtBqjsWuor6G/7yoD09L7+/hs5Q6oFMJgRZjrxn7m2+J6rjSSpdprcanr7+1f6tI7qK5k47qDNT3b4U0US9W3/xMASncbPWGjQcIl4WooU5PwvRTWUgXwhLDoLhvJfhrPXZ0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710123433; c=relaxed/simple;
	bh=1L7MoSZFuvPSNtlP8t+DsIgAFz3OYQfQmtdX/FZeVDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OZbbD70lnA1r7CCGi7bchajr0jG0BMlvJaQ0KstGj7KObjdR6IaSjxeRHpgirokpta8dPGM64quSK/AtIymO11Akmgn5HrNYbEqYIg+0sCBsbXLJWMh//VNI7sF22GnaWV7TZ0bgvwinemeDkYOwyiJsDYUO4E5CWpXvnvQA0Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=jCk0db+n; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="jCk0db+n"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-29bbff1505dso855991a91.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 10 Mar 2024 19:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710123431; x=1710728231; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P2HOPvTzIOfPgTuaGyDXCX6Oprhe2Q5xowyCchEBaBY=;
        b=jCk0db+nO/Lk+OXykEwsQIfoYn/mAi0EHmQXCu1T3dBwlf9+KTQiLrby5GBp93j7U7
         V5ghmYNvale5vaOcsnZ+1He+O8nnGePtL2AI9KIg8S++ZwY4GcGyJtBjqF6y7n8hL4sD
         j46+YkXWN7Dv4S2FZm/DzLh46ak9YXGD+5wmbWSDv54w8oWWDrNLs6RfrvlbBdOv9kg4
         5sc4C5KzOT89NoK6Y3b2z4gB397PO7ySMlN4Qmk9wXAxMlTfgceg4KFbcfsxr79qz1Zx
         rtEI2xQihYLAwHnQH6V5mtU2k1CinLV/rS4y+0Pdh0uVG84aHteeiyNLpTxFKUctBVSb
         6Otg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710123431; x=1710728231;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P2HOPvTzIOfPgTuaGyDXCX6Oprhe2Q5xowyCchEBaBY=;
        b=rPBuQUjm/cq9FxOh5gC0TvC7RlYtiBIv/hRF1CEtwj4rViWi/0ItSptKAyFw6IenwP
         KIwI5TbbAWC47iS6mvWVd7+y8QBuhvFSI+EVRTSgBCbm9d3vfixm9xDTlrQhQY02zWpE
         TVVtvhQo5lwFvSdrahDNRTFvFcO+dTIc1HliN0ioD7O/CGedLHJk0uDceJ94unPFcNUr
         01+79Gpl83pp+QGJOlWUkS2dmxFivsGSMFH1A4zVAKDkyAvICn55/GsojzD0G2M0pGkI
         plWL/6Ni/Ntx84yE5pN1MlPB5O6e5c/Dq25YiBanzsmm35yUmacQvP7BF0Xdeo5s8NaC
         6S8A==
X-Forwarded-Encrypted: i=1; AJvYcCXHj1BCbPf4PKEgFG5XexVUyvC5EQmFAUxvXQ23ej4zEWiDvFAxeCAGLzOjnuN3u1Dx1E864fIfPFlKDUnHp32olWOKUdD9bDFvHeqKhj0=
X-Gm-Message-State: AOJu0YwKD1o9KgdQlpoPHHOD4bcivPTTA6LJC/08+PzQYzZGgc7FlQKu
	4B9ZZRAAzL2qJCXUvDwUXOWE8qJzRCtlYpKZrXFqS8RygXecBL1ShuYcxrrKIT0=
X-Google-Smtp-Source: AGHT+IEgtGW5AN8mnjwdibd+gLuySW0tEDIBlzlkkIrMs8fV0hgNTvd0J7PfU9RiDNuMx2cvGySV0Q==
X-Received: by 2002:a17:90a:f417:b0:299:a69:1f8b with SMTP id ch23-20020a17090af41700b002990a691f8bmr3199478pjb.23.1710123431284;
        Sun, 10 Mar 2024 19:17:11 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-47-118.pa.nsw.optusnet.com.au. [49.179.47.118])
        by smtp.gmail.com with ESMTPSA id p3-20020a17090a348300b0029bc1c931d9sm3752893pjb.51.2024.03.10.19.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Mar 2024 19:17:10 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rjVDw-000GCA-1X;
	Mon, 11 Mar 2024 13:17:08 +1100
Date: Mon, 11 Mar 2024 13:17:08 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Neal Gompa <neal@gompa.dev>, linux-fsdevel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2] statx: stx_subvol
Message-ID: <Ze5ppBOFpVm1jyb+@dread.disaster.area>
References: <20240308022914.196982-1-kent.overstreet@linux.dev>
 <CAEg-Je96OKs_LOXorNVj1a1=e+1f=-gw34v4VWNOmfKXc6PLSQ@mail.gmail.com>
 <i2oeask3rxxd5w4k7ikky6zddnr2qgflrmu52i7ah6n4e7va26@2qmghvmb732p>
 <CAEg-Je_URgYd6VJL5Pd=YDGQM=0T5tspfnTvgVTMG-Ec1fTt6g@mail.gmail.com>
 <2uk6u4w7dp4fnd3mrpoqybkiojgibjodgatrordacejlsxxmxz@wg5zymrst2td>
 <20240308165633.GO6184@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240308165633.GO6184@frogsfrogsfrogs>

On Fri, Mar 08, 2024 at 08:56:33AM -0800, Darrick J. Wong wrote:
> Should the XFS data and rt volumes be reported with different stx_vol
> values?

No, because all the inodes are on the data volume and the same inode
can have data on the data volume or the rt volume. i.e. "data on rt,
truncate, clear rt, copy data back into data dev".  It's still the
same inode, and may have exactly the same data, so why should change
stx_vol and make it appear to userspace as being a different inode?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
