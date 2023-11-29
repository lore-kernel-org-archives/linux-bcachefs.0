Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="zd/RjNXC"
Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFB4D69
	for <linux-bcachefs@vger.kernel.org>; Wed, 29 Nov 2023 12:25:41 -0800 (PST)
Received: from eig-obgw-6008a.ext.cloudfilter.net ([10.0.30.227])
	by cmsmtp with ESMTPS
	id 8KatrXtGEWcCI8R7srvNLX; Wed, 29 Nov 2023 20:25:40 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id 8R7rruOzL0xkr8R7rrMie6; Wed, 29 Nov 2023 20:25:39 +0000
X-Authority-Analysis: v=2.4 cv=N7U6qkxB c=1 sm=1 tr=0 ts=65679e43
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=7m0pAUNwt3ppyxJkgzeoew==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=BNY50KLci1gA:10 a=wYkD_t78qR0A:10 a=VwQbUJbxAAAA:8
 a=QyXUC8HyAAAA:8 a=cm27Pg_UAAAA:8 a=OF05aalTVPlpCPcANIMA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=xmb-EsYY8bH0VWELuYED:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=X9PfSXn7t68Xlz7c+nvYbrRm7E2SUhd1bYPLGI3AcUY=; b=zd/RjNXClZW/9iU4JNIKXpXvVS
	SxEFr7kciKd2cTEIOajoIsZ+JzFyJjF5jpLqyCWRb/lE3FIvCE1385Ctj3s9kGVkXvqGuLWchSUmC
	yEXT6FuiJjBMyScyf+AEMaZMQ5LPupcq+d+Q3ct7RWDAp4sZiffJrMBq1NRQz1t0jJGDH0Ta50Ek7
	GODzdqXjRiETgDlx4g/6aCHR1o0zZvfKYF5ZS7uDsdNFDNa8zMEu2EwVGpfkQ6AWJb6+YRPOU2NTz
	CHtBE0V8mv5Ss/widskIPGwqI7Ba2kEW72z1V0vKgHp4tM1xxnfB6lPsMp8UU1b7gxwLq2HPZhdmR
	T27c4pww==;
Received: from 187.184.156.122.cable.dyn.cableonline.com.mx ([187.184.156.122]:36057 helo=[192.168.0.28])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <gustavo@embeddedor.com>)
	id 1r8R7q-003RPp-2V;
	Wed, 29 Nov 2023 14:25:38 -0600
Message-ID: <d63db040-1635-426a-8d3c-0b755187ba2e@embeddedor.com>
Date: Wed, 29 Nov 2023 14:25:36 -0600
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] bcachefs: Replace zero-length arrays with
 flexible-array members
Content-Language: en-US
To: Kees Cook <keescook@chromium.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <ZWYv/ywR/qxUhVSU@work> <202311291215.9BBCD8E@keescook>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <202311291215.9BBCD8E@keescook>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.184.156.122
X-Source-L: No
X-Exim-ID: 1r8R7q-003RPp-2V
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187.184.156.122.cable.dyn.cableonline.com.mx ([192.168.0.28]) [187.184.156.122]:36057
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfD+/tweFSbZx0XQAxe6L9Z3CKVPTMJChRgXB6+nQlywPrxEKiFGWLuoGsuSKzSpjc0FmrDq2DRAa32RIGIjDh8akZhMeKeSPYCnsU77CZKW48xROKktu
 Nf03jG39AjwUdEzHqdrv/o1OElu9j4A50k+TIFdSH5Kr8/HFfhariHE1T2d/Nr61VQOn0jfb1rusK8l9svBf7lEXkN4tCPkxtbkyPX9VXmQ3Qxi2ZsN9ns59



On 11/29/23 14:15, Kees Cook wrote:
> On Tue, Nov 28, 2023 at 12:22:55PM -0600, Gustavo A. R. Silva wrote:
>> Fake flexible arrays (zero-length and one-element arrays) are
>> deprecated, and should be replaced by flexible-array members.
>>
>> So, replace zero-length arrays with flexible-array members
>> in multiple structures.
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> These look like straight-forward conversions. Thanks!

Yep, these also fix a buch of -Warray-bounds warnings reported
by 0-day:

https://lore.kernel.org/lkml/202311290720.TzNYq81c-lkp@intel.com/

> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 

Thanks!
--
Gustavo
