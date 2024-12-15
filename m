Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBE62F30;
	Sun, 15 Dec 2024 06:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734243635; cv=none; b=HDmRIZdYmfGaxJ2RGIopOf1AE0nv2cim99qtV11amFZkJE1pImU6WRnXoyKH77MKP3NSx34R4IWquwtfpTYVO2h2mDWwxn3YjsvUcCrpCX5/OQtTvIo+48SfDxhCmHHYYftLOCZcKZhaCLuUNA+BXCjX5qYTegavSB2AZlqYQWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734243635; c=relaxed/simple;
	bh=7q/EFTEZkvEQRMNFwmdIyNdUrqyI6U65YgDvqao73LM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kZ2qSPQNdaZIRYTzlFR7EOiTkwWZvjt0pv+JOWvlR2DZ+rpry4Zqlq+bS3DN01emGaYQQjLu9SGKy4OlYIPf1ry9xmnuDMUbpN8azwIk7aqFntbwYzaFP4uqdFeF/VOAT9Qy7gNVOCBzXaYDvW5Z6rg0BaSoI6zGxF/ujXuBsLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=faxp+J1v; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="faxp+J1v"
Date: Sun, 15 Dec 2024 01:20:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734243630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fLgnnSPoI2c0kMgWHCig3H9WgR5NjktMXGZjiE9opIg=;
	b=faxp+J1vagqminua0kqMTmDD8QNudAG4oNld3ksGdsuJIr3o46yRHSrOjBgO2fsDaniEaf
	5w94/PIdT9HoDpbL6BSOfTtr4RCI5JxKusBbClL8mZXR4l8uXNRUNOW63W9oyH9Le0s932
	voiJeIz/kxtBzU4JDAD1SBRoaS/CDr0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Gianfranco Trad <gianf.trad@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, syzbot+8689d10f1894eedf774d@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: zero-init move_bucket struct in
 bch2_copygc_get_buckets()
Message-ID: <p2qtcygjvkhyq5t4rqnmhscw5kwlm74ectyukmnc2eexiz35ue@xpmu2hlm7wnt>
References: <20241111144242.757798-3-gianf.trad@gmail.com>
 <vtm2n2sjx4kpkx4slzpve6pv4lxhmotnvrhtqp2qobrmubvz35@s33ak2pst3h2>
 <382408d3-21ed-4bb3-87a2-60ad61583726@gmail.com>
 <60464a9b-aa46-40b3-b8fa-0567f86f6747@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60464a9b-aa46-40b3-b8fa-0567f86f6747@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Dec 15, 2024 at 02:58:26AM +0100, Gianfranco Trad wrote:
> Hi Kent,
> 
> I wanted to follow up on this patch. Over the last few days, I've
> investigated it further and observed the following that might be of help:
> 
> 1- zero-initing whole b struct (as the first patch version) leads to a clean
> log [1].
> While if trying to memset to 0 only b.k field log reports [2]:
> 
> bcachefs (da441363-bb6a-4ab9-999b-c1f40db4fee2): filesystem UUID already
> open
> bcachefs (da441363-bb6a-4ab9-999b-c1f40db4fee2): shutdown complete
> bcachefs: bch2_fs_get_tree() error: EINVAL
> 
> 
> 2- Given both versions of the patch didn't trigger the uninit issue anymore
> I checked whether inner fields of b.k.bucket are correctly inited, just
> before the bug triggers.
> b.k.bucket fields seeming to look correctly inited: snapshot = 0, offset =
> 34, inode = 0, gen = 0.
> 
> 3- The first of the 2 reproducers causes a segfault:
> 
> ==9335== Invalid[  264.802101][ T9346] read of size 1
> ==9335==    at 0x483BC39: strnlen (vg_replace_strmem.c:426)
> ==9335==    by 0x1098F0: netlink_query_family_id (repro.c:176)
> ==9335==    by 0x109A51: syz_genetlink_get_family_id (repro.c:211)
> ==9335==    by 0x10B476: execute_one (repro.c:2071)
> ==9335==    by 0x10B1A5: loop (repro.c:745)
> ==9335==    by 0x10B52F: main (repro.c:2088)
> ==9335==  Address 0x0 is not stack'd, malloc'd or (recently) free'd
> 
> As of now, it seems unrelated to the root cause of the reported syzbot bug.
> 
> 
> At this point, zero-initializing the entire struct seems to work reliably,
> thought I'm still trying to get the full picture on this bug.

I think this might be a padding issue.

C struct literals are supposed to initialize the whole struct, but the
compiler folks in their infinite wisdom decided that didn't apply to
padding.

I think this needs to be raised with the KMSAN and compiler folks, as
inserting memsets all over the place would be a sad workaround.
