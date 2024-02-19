Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888B553E3E
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 21:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708378703; cv=none; b=eZH+Ncr5WGO8ISeZImcZh82viEgMyZ+jafzZKLXOykcl5B8CyxDmK0aAoQQZujNvbJzq723rUSND6qbBG0JQVv7Hr/glWPEvq2BLQBOjAboA3ASWcV5GLSE1EWcItzEJCX4zolH1yHTravSX9ETTocqG2e0urZdx0Pgnxs63fno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708378703; c=relaxed/simple;
	bh=kO132W8VqA0lD1aQkVq+6FYNc/RgNUSWNOzioNfJoaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aUtZi2MCtnEWG4C+pd7cmTon7mtCmAlurp1/hx6fFwK0Hnr29cNqVtc58p872y5A4oXMiia196QlJmikhNAWCiZ1E9VUw3Ibl+FEHRjb3O+8x4yZbBWrR93wpkVW2xa9NklHuqUpqweidN6BAkmCN32fLs0sNWr8eT6uc99Td9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LYgZZmdY; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LYgZZmdY"
Date: Mon, 19 Feb 2024 16:38:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708378699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WpuYG+h3TSgyJSJgZR3W7kq8XDyXD92PYjoj3CYxhKo=;
	b=LYgZZmdYURqdOY2BjU1tDAodlBauQ4yMQnodt1+ilDy29kY1R5fvMAPPf/Alv2+kADA69i
	InYCp5WEtaURfLXbDfINRsl4rjD2D7bH1xbUHqs1afhu3kPaq0WchaLZZhOcUO5N5oP5Af
	vBaw05jHnz79LjMrVIyafdgUabZFRDg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: David Laight <David.Laight@aculab.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>, 
	Arnd Bergmann <arnd@arndb.de>, Calvin Owens <jcalvinowens@gmail.com>, 
	Dave Martin <Dave.Martin@arm.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: [PATCH] arm: Silence gcc warnings about arch ABI drift
Message-ID: <msw3w26o27g2lvdgche535m47vqdzmr4g2evq5gc4uvmo5fqi2@bedh4opzimmt>
References: <fe51512baa18e1480ce997fc535813ce6a0b0721.1708286962.git.jcalvinowens@gmail.com>
 <431dd956-ad31-4da8-ad42-34f7380824bb@app.fastmail.com>
 <ZdMe24xN1Ej4QoVU@shell.armlinux.org.uk>
 <xs2splnjhlj257uca5yae64fp4solc4ugbxrkczoyd75n42r66@42boyzdcmyj4>
 <ZdMkyPX/h9s8xht5@shell.armlinux.org.uk>
 <fharyfc7fnh45dthgd2ehwsgdqzmdfptp7jw7gi5ahb6slwgf6@nrkhlhvbbzx7>
 <ff0164553d6f486f97643eae8235cc5f@AcuMS.aculab.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff0164553d6f486f97643eae8235cc5f@AcuMS.aculab.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 19, 2024 at 07:53:15PM +0000, David Laight wrote:
> ...
> > I'm not always trying to write code that will generate the fastest
> > assembly possible; there aro other considerations. As long a the
> > compiler is doing something /reasonable/, the code is fine.
> 
> Speaks the man who was writing horrid 'jit' code ...
> 
> This also begs the question of why that data is so compressed
> in the first place?
> It is quite likely that a few accesses generate far more code
> than the data you are attempting to save.

It's easy to understand if you understand profiling, benchmarking and
cache effects.

That 'jit code' is for _all_ filesystem metadata.
