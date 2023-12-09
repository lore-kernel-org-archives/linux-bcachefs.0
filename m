Received: from cdw.me.uk (cdw.me.uk [91.203.57.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id B12EC1A1
	for <linux-bcachefs@vger.kernel.org>; Sat,  9 Dec 2023 05:10:41 -0800 (PST)
Received: from [148.252.147.228] (helo=smtpclient.apple)
	by delta.arachsys.com with esmtpa (Exim 4.80)
	(envelope-from <chris@arachsys.com>)
	id 1rBx6N-0002Ez-VI
	for linux-bcachefs@vger.kernel.org; Sat, 09 Dec 2023 13:10:40 +0000
From: Chris Webb <chris@arachsys.com>
Content-Type: text/plain;
	charset=us-ascii;
	delsp=yes;
	format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.15\))
Subject: Re: [PATCH 2/2] bcachefs-tools: Avoid glibc-specific mallinfo() in
 shrinker
Date: Sat, 9 Dec 2023 13:10:38 +0000
References: <2d7abd52206065d763691b082e089811e1e2b962.1702125906.git.chris@arachsys.com>
 <a954a56e0923e067d646f584fc3838bdeae9e2d7.1702125906.git.chris@arachsys.com>
To: linux-bcachefs@vger.kernel.org
In-Reply-To: <a954a56e0923e067d646f584fc3838bdeae9e2d7.1702125906.git.chris@arachsys.com>
Message-Id: <A8210FBA-2AFF-4ADE-87AF-654A0AFB48A7@arachsys.com>
X-Mailer: Apple Mail (2.3654.120.0.1.15)

Chris Webb <chris@arachsys.com> wrote:

> +	/* Aim for 6% of physical RAM free without anything in swap */
> +	want_shrink = (info.totalram << 4) - info.freeram
> +			+ info.totalswap - info.freeswap;
> +	if (want_shrink <= 0)
> +		return;

(info.totalram >> 4) here, sorry, of course!

Best wishes,

Chris.
