Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1653B26A1BB
	for <linux-bcachefs@vger.kernel.org>; Tue, 22 Jul 2025 18:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753208881; cv=none; b=N5y3ZsunCMqEKGNXHAzp6W29rjbh8mM7LfZ/cQ6U/Urtd2kStUxUb/Wdl04cH7CKi75qhHiFfud+u/ZQY8oetNLo+Mcc2NV/f13A+d1niA34x7C6RqFpPk7iGYnQTM2zp3xG9S/d9GRqRS1AvsgSqsR/lpO6fK/B87qArqNy9kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753208881; c=relaxed/simple;
	bh=GJLEN+lCnN/TVYKqEOZIka4Ewdts5m7DcyKZncDxP6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WvWVQGqFZ3S+04+lpW+xkHVJMCNUsfDGL4LJ/fmKhDIketQ5QFezpG3w7Kwk4Cg/dHzNSAkcEiAk2tROZIYYoYZnZpOyDdumAtDurfMnq6BjYGLOF7bHx0t7egFiXLDGNWAHLIf3yFaG1ofsHZr5qwVlRNEYkgwHSnyhExB7Dc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hEfrNtoB; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hEfrNtoB"
Date: Tue, 22 Jul 2025 14:27:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753208877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mi7Dy3DyQ/072Eng7iKuH2jusdHjQ9q25rYJBgy2hVk=;
	b=hEfrNtoBaGc71iw/XJ9gfELBNa/yjflx5Pwa2soNnrnPbyEOUz3ekulAwGvo1TJQVwp7Qo
	Fywl6T3WcP4z9Mlx4b/GeMaGpgLDEVNZ+N8/a3/JRXOs6Ih3539/LLhQns9jY3V2z7cFHR
	1mn3bC8Hi7DSDB/c+dJ5G4lRgcPFcQ0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: anindya19@gmail.com
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH] bcachefs: remove extraneous ; after statements
Message-ID: <c5inmf4l73sn7ckyp6zbvprchwqygrlucojh4fk5pmofmohsep@vorf7mtrnxqx>
References: <20250722182310.11931-1-anindya19@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250722182310.11931-1-anindya19@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jul 22, 2025 at 11:53:10PM +0530, anindya19@gmail.com wrote:
> From: Anindya Sundar Gayen <anindya19@gmail.com>
> 
> There are a couple of statements with two following semicolons, replace
> these with just one semicolon.
> 
> Signed-off-by: Anindya Sundar Gayen <anindya19@gmail.com>

Applied
