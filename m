Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF941CB31D
	for <linux-bcachefs@vger.kernel.org>; Mon, 13 Jan 2025 20:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736799247; cv=none; b=uIaTxu0Sn0JD3/iblkg6JGsSeaG/AicD4zXzpGicaB90Lm9JWlPfcOnUPyYubTniyjTLKWVs4vgMxKxKsKpUis7Gw3BfP/KYEDneKGBLPur2FBTmWTEUVsRMp/OTq/QFFOJtcrl1pU4zQ7/nvd/iXeLmWTJt8GR9g+FiC2aAssg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736799247; c=relaxed/simple;
	bh=I6BCdVkSKePpfte9K21b1uFT87AKFhrtoAfKpNJTca4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tSJCLGhbPh2uL6O8o+w1YAD7qaNHRWuW/DArxZMdVHhO4KKClejdHkCuj9D/aSnvyBDwfju1bZ0WyxS1D5lUfJersJPmYX8vxnc/wKjRewfXzxIyMNI+D/idl+VsscpZCnMoTzfE2nbeGF1YTDpZPZuHPMLWzcZ+7WvZLm3fSNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Vd7vk3Ei; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Vd7vk3Ei"
Date: Mon, 13 Jan 2025 15:13:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736799240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ialQt463ewFQMo3Ab6x5LyB3bXupAhkBUQpBSP8uz9o=;
	b=Vd7vk3EiurVBvvbPSHrv0rmbNkZwvap3oJ+hOn2Y8ICY2cQRAjvA6WgFegajcg0Ch586u3
	HVYJvzIBuf0YwuU1wEx/wHMtDZYHmskePP1K9ai53pqOLF8ROEOv5gZhuIx6Qr4hkYOu7Z
	whXoeEY4l6yDxrWSdd/P3yyK+6IOWdg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: The missing patches
Message-ID: <ysrspb3ucac54cemtmlwmxuskgypm655cqkfwni5v7bsbcenvp@xs5l6f7bnm4n>
References: <99F79FA0-61D0-4E27-85E5-3D8ADC676D63@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <99F79FA0-61D0-4E27-85E5-3D8ADC676D63@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 09, 2025 at 03:17:34PM +0800, Alan Huang wrote:
> Hello Kent,
> 
> Here are the links to the missed patches, I’d like to know if these patches are still needed :)
> 
> [1] https://lore.kernel.org/all/20240925164500.1178107-1-mmpgouride@gmail.com/T/
> 
> [2] https://lore.kernel.org/all/20240925164602.1179117-1-mmpgouride@gmail.com/T/
> 
> [3] https://www.mail-archive.com/linux-bcachefs@vger.kernel.org/msg02925.html
> 
> [4] https://lore.kernel.org/all/B0F9A8E3-F19D-4660-881F-14C40D740910@gmail.com/T/

Applied
