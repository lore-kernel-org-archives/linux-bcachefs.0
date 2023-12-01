Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nzRNX2Om"
Received: from out-5.mta0.migadu.com (out-5.mta0.migadu.com [IPv6:2001:41d0:1004:224b::5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86C993;
	Thu, 30 Nov 2023 17:51:00 -0800 (PST)
Date: Thu, 30 Nov 2023 20:50:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701395458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VHXedy8xbcqkzZT8Ih0cSVGgu9ZBkB3FcdSy3+7Tduc=;
	b=nzRNX2OmMBP2QjrEX775fBmNbNRk4jTWa6HbTH+TzPX47fcwHcRKRpebPLIMRkX0as4X1S
	nR7CfE2ruL7L/qRuy/F47AQ6UCe98mFXPhFLFhDb9bhSpFxPr8VUkMueV276ssnCvsQElS
	5YFyEyChRH0HZoEAfGEyTq0bDBRQrVs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Daniel J Blueman <daniel@quora.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs page fault oops after device evacuate/remove and unmount
Message-ID: <20231201015055.pn5qqbsk42jlfsoc@moria.home.lan>
References: <CAMVG2stxMYZbDoAHeVQjgJ7f+Td7+VJrLNRbY8au68ZVkzhb0g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMVG2stxMYZbDoAHeVQjgJ7f+Td7+VJrLNRbY8au68ZVkzhb0g@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 30, 2023 at 08:47:33PM -0500, Daniel J Blueman wrote:
> Hi Kent et al,
> 
> On upstream bcachefs (master @ evilpiepirate.org/git/bcachefs.git) SHA
> f8a1ba26, I was able to develop a minimal reproducer [1] for a page
> not present oops I can provoke [2]. It appears we need further
> synchronisation during unmount.
> 
> Let me know when there is a patch I can test, or for debug.

There was a device removal that was just fixed, I've already sent the
pull request to Linus but in the meantime try this branch:

https://evilpiepirate.org/git/bcachefs.git/log/?h=bcachefs-for-upstream

If you still hit it, I'll turn your reproducer into a ktest test and
hunt it down.
