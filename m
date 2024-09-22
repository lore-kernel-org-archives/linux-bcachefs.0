Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C39A5579F
	for <linux-bcachefs@vger.kernel.org>; Sun, 22 Sep 2024 20:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727037373; cv=none; b=poT3qHHBe/XnME1wv1Ws/ufsfn/S477FVzYLDjqkP3oSicHL1JnvIqOJuH6zrrhAMrinil/RiNkpqESGXk8/oCiCdAtBlE+n+b0NdNP7vnvN2NAlRzZDHJX/n1jKz/4xoag1/51SseHFgVT75bd82OZytbXPOx3iKCvVcUBUzPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727037373; c=relaxed/simple;
	bh=rI6bXw6V2zfI+VhzT2ECp/Fa+q3QtrALfg5WAAPwYjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pniqfb7gDcwKa/N1faKIylseng1XXdHi+x3tAR1MwYjaAOpspWXLNwL5MFoJFw0HFcchyVBOK6jfkTK/knpeAwm5/8bik81h78xrAyCSgd5YCRU0uTkoKvFUbeh+/ErnRfchfdIxyUL4ENOfY9HnvDjAkXV8qj/9QI7wXBhPxtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=W/XFr+eF; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="W/XFr+eF"
Date: Sun, 22 Sep 2024 16:36:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727037368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8i4ZbW+AJjV/JkG8lWXhPeWGFq3c6CnqcF50KqL/Ob8=;
	b=W/XFr+eFbLbvNOBgeOt/OWeuvXFReq29oiJojE0UWw6RRZL9DyBn4W447NpnmS1XQlYjZy
	aGSoxSqN3nHGx8ao1kjVFF4U2FfORaIs4YgVacqtlK4j5g7PUhqw7a8ORkZ0Xz4/ddD5dB
	3lbMQl+tJxHeJOJcOtfzlOr8Vcv39z0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hanno =?utf-8?B?QsO2Y2s=?= <hanno@hboeck.de>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: mount hangs / kernel BUG on attempt to mount or fsck /
 bch2_accounting_read
Message-ID: <pvga5sgp4vejnnr5ojgiuwte6qeve4x7ld4dhdmzb625l367fq@q4td2cutlfvu>
References: <20240917142815.3c1c3c95.hanno@hboeck.de>
 <vn5klwwam3pvalfkexq3uroryx4t6ixpeldjjjm6zl6rmbp3tx@ftthpbbpttzf>
 <20240922185941.7b9680de.hanno@hboeck.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240922185941.7b9680de.hanno@hboeck.de>
X-Migadu-Flow: FLOW_OUT

On Sun, Sep 22, 2024 at 06:59:41PM GMT, Hanno Böck wrote:
> On Sat, 21 Sep 2024 19:45:12 -0400
> Kent Overstreet <kent.overstreet@linux.dev> wrote:
> 
> > Fixing the BUG_ON() and getting you going again will be easy, but I
> > want to know what the underlying bug was...
> > 
> > Could you run 'bcachefs list_journal -a -k accounting <device>'?
> 
> Off-list, not sure whether this contains any confidential info. 
> The file was 178 MB, but highly compressable, see attachment.

Thanks!

You've got accounting keys in there with version=0 - _that's_
interesting...
