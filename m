Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6991B3950
	for <linux-bcachefs@vger.kernel.org>; Wed, 26 Mar 2025 16:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743005878; cv=none; b=hsXCg4qZIJffPbUJU7hq2oPjiMUfmBBnP9n1MPrgf/x4+YnL2QeJZ1kCOvqNAn20Ht6yBzrZ0IlfUJf1T9SyeI8a04P5TWHv3rEzYlGVoPsKxzkxIyGEq1oCBYrZH4mYj/Ld+yyTFEt+pVqZW2+aUNiA1Jd1Qhzw9zKMFRA+ax8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743005878; c=relaxed/simple;
	bh=ofP62jXvBIqAWzWviTNCbSn41MACM6sOf1GC1vNYNR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tT5Ejl1x4MpDsJVLRSf0UJ2u1Ss7xn7lZnBvtUylRXol9FOvrsBBF/40pG2+Xo8TbHNPVAjNG9oRuLqJHedoNIo9W4Onb+VDYzevFzK+eS1uT1ItT/1SoWVPmCPqAQYPn+RcO/cOcgrhpjUfGXTUuVlAn7qfsTl3wyMjwRSZkpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GSoYnput; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GSoYnput"
Date: Wed, 26 Mar 2025 12:17:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743005874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8j2vw7QjUbZln+KhxU2q51f1/Vi5QWt5LCZG2SQyQhc=;
	b=GSoYnput23BCDTjyJjM3MqjCtBm+2shfO+gy5phrERaIjJOYOW44aYxDzadqpjMY6qjAID
	j+pjMA0G7vSRllMl99Djsm+09LgA968lV81iPkiEtyyUwo25AxFCNK5/pbEEebDi3d83gP
	n1tyvvzhcbvGGqdG2lakaO39gyjMloU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
Cc: Roxana Nicolescu <nicolescu.roxana@protonmail.com>, 
	Alan Huang <mmpgouride@gmail.com>, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] bcachefs: replace deprecated strncpy() with strscpy()
Message-ID: <vfszytfd66lqj54nmkymhnrdjodylb7l3alxblzixnlzv7kxom@4dji3xuvmknj>
References: <20250326094449.16473-1-nicolescu.roxana@protonmail.com>
 <5F3AB2BC-43DA-47A6-A07A-72540B327D11@gmail.com>
 <bmjvipermsvb454mdh5zmlmw4gv4oub5fgh4eowedlit75gqei@3or3va3e52ce>
 <MnHJR6KH9EcCqnLtdxKf3XYBSQQbvXWJafG28O2C2itnS_eETVFoDMfVvFva3dkLMZ-LPRWUhG2g_5HBY_lPZkWOYW2aOg_T4YWTrzXmVZ0=@protonmail.com>
 <wdagx2vwyv7s2t2tcndwmambwdhmoitvhmnzcopdl3xkfq6ct2@evmzpxnuhi4e>
 <CAPZ5DTF+Q_-10xF915wF3b3aUm5jqZepqoyivF+G4S6ONf_PcQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPZ5DTF+Q_-10xF915wF3b3aUm5jqZepqoyivF+G4S6ONf_PcQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 26, 2025 at 09:19:06PM +0530, Bharadwaj Raju wrote:
> On Wed, Mar 26, 2025 at 8:22 PM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> > Or better, a new helper: when we're copying to a fixed size buffer we
> > really want to zero out the rest of the buffer - we don't just want a
> > single terminating nul.
> 
> I believe strscpy_pad does this?
> 
> https://docs.kernel.org/core-api/kernel-api.html#c.strscpy_pad

almost, we don't want the 'required nul termination'; that's a
requirement at least for disk labels where we need to preserve existing
behaviour
